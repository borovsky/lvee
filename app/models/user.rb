require 'digest/sha1'
class User < ActiveRecord::Base

 # Authorization plugin
 # acts_as_authorized_user
 # acts_as_authorizable

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of :login, :message => '^Заполните поле Login'
  validates_presence_of :email, :message => '^Заполните поле Email'
  validates_presence_of :first_name, :message => '^Вы забыли указать своё имя'
  validates_presence_of :last_name,  :message => '^Вы забыли указать фамилию'
  validates_presence_of :country,    :message => '^Укажите вашу страну'
  validates_presence_of :city,       :message => '^Укажите ваш населенный пункт'

  validates_presence_of     :password,                   :if => :password_required?, :message => '^Вы должны выбрать пароль'
  validates_presence_of     :password_confirmation,      :if => :password_required?, :message => '^Подтверждение пароля не совпадает с введенным паролем'

  password_lenght_error = '^Пароль должен быть длинной от 4 до 40 символов'
  validates_length_of       :password, :within => 4..40, :if => :password_required?, :allow_blank => true, 
                                                         :too_short => password_lenght_error, :too_long => password_lenght_error

  validates_confirmation_of :password,                   :if => :password_required?, :message => '^Подтверждение пароля не совпадает с введенным паролем'

  validates_format_of :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix , :message => '^Ваш Email содержит ошибки'

  validates_length_of       :login, :within => 3..40, :message => '^Пароль должен быть более 3х символов, но менее 40'

  validates_length_of       :first_name, :within => 2..30, :allow_blank => true, :message => '^Имя должно быть указано'
  validates_length_of       :last_name, :within => 2..30,  :allow_blank => true, :message => '^Фамилия должна быть указана'

  validates_uniqueness_of   :login, :message => '^К сожалению выбранный вами логин кто-то уже занял'
  validates_presence_of     :email, :case_sensitive => false, :message => '^К сожалению выбранный вами клиент кто-то уже занял'

  before_save   :encrypt_password
  before_create :make_activation_code

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :first_name, :last_name, :country, :city, :occupation, :projects, :proposition

  def full_name
    [first_name, last_name].join(' ')
  end

  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
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
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def editable_by?(user)
    self.id == user.id # by self and only self ;)
  end

  def site_editor?
    SITE_EDITORS.include? self.login
  end

  protected
    # before filter
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def password_required?
      crypted_password.blank? || !password.blank?
    end

    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

end
