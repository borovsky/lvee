require 'digest/sha1'
require 'maillist_subscriber'

class User < ActiveRecord::Base
  mount_uploader :avator, UserUploader

  has_many :conference_registrations, :dependent => :delete_all
  has_and_belongs_to_many :abstracts, :join_table => "users_abstracts", :uniq => true

  # Virtual attribute for the unencrypted password
  attr_reader :password
  
  # Virtual attribute for disable mail sending
  attr_accessor :no_mail

  REQUIRED_FIELDS = [:city, :occupation]

  validates *REQUIRED_FIELDS, :presence => true

  PASSWORD_VALIDATOR =  {:if => :password_required?, :presence => true, :length => {:within => 4..40}}

  validates :login, :presence => true, :length => {:within => 3..40}, :uniqueness => true

  validates :password, PASSWORD_VALIDATOR.merge(:confirmation => true)
  validates :password_confirmation, PASSWORD_VALIDATOR

  validates :email, :presence => true, :format=>{:with => /^[a-zA-Z0-9\-\._]+\@[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})$/ix}

  validates :first_name, :presence => true, :length => {:within => 2..30}
  validates :last_name, :presence => true, :length => {:within => 2..30}

  before_create :method => :make_activation_code
  after_save :method => :subscribe_to_lists

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :first_name, :last_name, :country, :city, :projects, :occupation, :email, :password, :password_confirmation, :subscribed, :avator, :avator_temp

  def full_name
    "#{first_name} #{last_name}"
  end

  def from
    "#{city}, #{country}"
  end

  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(:validate => false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = where('login = ? and activated_at IS NOT NULL', login).first # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}-")
    save(:validate => false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(:validate => false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def editable_by?(user)
    self.id == user.id # by self and only self ;)
  end

  def admin?
    self.role == 'admin'
  end

  def editor?
    ['admin', 'editor'].include?(self.role)
  end

  def reviewer?
    ['admin', 'editor', 'reviewer'].include?(self.role)
  end

  def self.valid_data
    {:login => 'login', :email => 'user@example.com',
      :first_name => 'Vasiliy', :last_name=> 'Pupkin',
      :country => 'Belarus', :city => 'Minsk',
      :password => '1234',
      :password_confirmation => '1234',
      :occupation => "Some",
      :projects => "Any"}
  end

  def to_s
    "#{full_name}"
  end

  def subscribe_to_lists
    if subscribed?
      MaillistSubscriber.subscribe(ALL_USER_MAILLIST, self.email) if active?
    else
      MaillistSubscriber.unsubscribe(ALL_USER_MAILLIST, self.email)
    end
    if subscribed_talks?
      MaillistSubscriber.subscribe(TALKS_MAILLIST, self.email) if active?
    else
      MaillistSubscriber.unsubscribe(TALKS_MAILLIST, self.email)
    end
  end

  def loaded?
    true
  end

  def self.create_imported(base)
    u = User.new
    base.each_pair do |k, v|
      unless %w(site id age profession avator role).include? k
        u.send((k + "=").to_sym, v)
      end
    end
    u.no_mail = true
    if(u.save)
      if base['activated_at']
        u.no_mail = true
        u.activate
      end
      "User #{u.login} (#{u.email}) has been created"
    else
      "Error saving user #{u.login} (#{u.email}): <ul><li>" + u.errors.full_messages.join("</li><li>") + "</li></ul>"
    end
  end

  def password=(new_password)
    return if new_password.blank?
    @password = new_password
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(new_password)
  end

  protected
  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
end
