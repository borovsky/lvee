class ConferenceRegistration < ActiveRecord::Base
  belongs_to :user
  belongs_to :conference

  has_many :badges, :dependent => :delete_all

  validates :user_id, :presence => true
  validates :conference_id, :presence => true, :uniqueness => {:scope => :user_id}
  validates :transport_to, :if => :check_transport, :presence => true
  validates :transport_from, :if => :check_transport, :presence => true
  validates :quantity, :numericality => {:only_integer => true, :greater_than => 0}, :presence => true

  attr_accessor :admin

  scope :actual_for_user, lambda{|user| where("conference_registrations.user_id = ?", user).order("conferences.start_date").includes(:conference, :user)}
  scope :participants, lambda{|conference|
    where("conference_id = ? AND status_name <> ?", conference, CANCELLED_STATUS).includes(:user).
      order("users.country ASC, users.city ASC, users.last_name ASC, users.first_name")
  }
  attr_accessor :import

  attr_accessible :user_id, :conference_id, :transport_from, :transport_to, :quantity

  def status
    @status ||= Status.find_by_name(@status_name)
    @status
  end

  def status=(status)
    self.status_name = status.name
    @status = status
  end

  def approved?
    status_name == APPROVED_STATUS
  end

  def cancelled?
    status_name == CANCELLED_STATUS
  end

  def cancel!
    self.status_name = CANCELLED_STATUS
    save!(validate: false)
  end

  def login
    user.login
  end

  def self.for_user(user_id)
    self.where(:user_id => user_id).includes(:conference, :user).order("conferences.start_date")
  end

  def filled?
    ((self.quantity || 0) > 0) and
      !self.days.blank? and
      !self.transport_to.blank? and
      !self.transport_from.blank?
  end

  def self.participants(conference)
    find(:all,
      :conditions => ["conference_id = ? AND status_name <> ?", conference, CANCELLED_STATUS],
      :include => [:user],
      :order => "users.country ASC, users.city ASC, users.last_name ASC, users.first_name")
  end

  def self.create_imported(conference, user)
    cr = ConferenceRegistration.new(:user => user, :conference => conference, :quantity => 1)

    cr.import = true
    if(cr.save)
      "Created registration for #{user.login} (#{user.email}) to conference #{conference.name}"
    else
      "Error saving conference registration for #{user.login} (#{user.email}): <ul><li>" + cr.errors.full_messages.join("</li><li>") + "</li></ul>"
    end
  end

  protected
  def check_transport
    !admin && approved? && !import
  end

  validate do
    if status_name == APPROVED_STATUS && !admin
      self.errors.add("quantity",
        I18n.t("activerecord.errors.messages.less_than_or_equal_to",
          :count => self.quantity_was)) if self.quantity_was && (self.quantity.to_i > self.quantity_was)
    end
  end

end
