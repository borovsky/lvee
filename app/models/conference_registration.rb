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

  after_save :method => :do_after_save

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
    save!
  end

  def self.find_actual_for_user(user_id)
    ConferenceRegistration.find(:all,
      :conditions => ['user_id = :user_id', {:user_id => user_id}], :order => "conferences.start_date",
      :include => [:conference, :user])
  end

  def filled
    ((self.quantity || 0) > 0) and
      !self.days.blank? and
      !self.transport_to.blank? and
      !self.transport_from.blank?
  end

  def populate_badges
    if quantity
      while badges.length < quantity
        self.badges.create(:top => self.user.full_name, :bottom => self.user.from)
      end

      while badges.length > quantity
        self.badges.delete(self.badges.last)
      end
    end
  end

  def self.participants(conference)
    find(:all,
      :conditions => ["conference_id = ? AND status_name <> ?", conference, CANCELLED_STATUS],
      :include => [:user],
      :order => "users.country ASC, users.city ASC, users.last_name ASC, users.first_name")
  end

  protected
  def check_transport
    !admin && approved?
  end

  validate do
    if status_name == APPROVED_STATUS && !admin
      self.errors.add("quantity",
        I18n.t("activerecord.errors.messages.less_than_or_equal_to",
          :count => self.quantity_was)) if self.quantity_was && (self.quantity.to_i > self.quantity_was)
    end
  end

  def do_after_save
    populate_badges
    if self.status_name_changed?
      UserMailer.deliver_status_changed(self)
    end
  end
end
