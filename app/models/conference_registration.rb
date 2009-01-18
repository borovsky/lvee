class ConferenceRegistration < ActiveRecord::Base
  belongs_to :user
  belongs_to :conference

  validates_presence_of :user_id
  validates_presence_of :conference_id

  validates_uniqueness_of :conference_id, :scope => :user_id

  def status
    Status.find_by_name(@status_name)
  end

  def status=(status)
    self.status_name = status.name
  end

  def self.find_actual_for_user(user_id)
    ConferenceRegistration.find(:all,
      :conditions => ['user_id = :user_id', {:user_id => user_id}], :order => "conferences.start_date",
      :include => [:conference, :user])
  end
end
