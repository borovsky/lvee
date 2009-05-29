class ConferenceRegistration < ActiveRecord::Base
  belongs_to :user
  belongs_to :conference

  validates_presence_of :user_id
  validates_presence_of :conference_id
  validates_presence_of :transport_to, :if => :check_transport
  validates_presence_of :transport_from, :if => :check_transport

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
    admin && status_name == 'activated'
  end
end
