class ConferenceRegistration < ActiveRecord::Base
  belongs_to :user
  belongs_to :conference

  validates_presence_of :user_id
  validates_presence_of :conference_id
  validates_presence_of :transport_to, :if => :check_transport
  validates_presence_of :transport_from, :if => :check_transport
  validates_numericality_of :quantity, :only_integer => true, :greater_than => 0

  validates_uniqueness_of :conference_id, :scope => :user_id

  attr_accessor :admin

  def status
    @status ||= Status.find_by_name(@status_name)
    @status
  end

  def status=(status)
    self.status_name = status.name
    @staqtus = status
  end

  def self.find_actual_for_user(user_id)
    ConferenceRegistration.find(:all,
      :conditions => ['user_id = :user_id', {:user_id => user_id}], :order => "conferences.start_date",
      :include => [:conference, :user])
  end

  protected
  def check_transport
    !admin && status_name == 'approved'
  end

  def validate
    if status_name == APPROVED_STATUS
      self.errors.add("quantity",
        I18n.t("activerecord.errors.messages.less_than_or_equal_to",
          :count => self.quantity_was)) if self.quantity_was && (self.quantity.to_i > self.quantity_was)
    end
  end
end
