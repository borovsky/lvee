class Conference < ActiveRecord::Base
  has_many :conference_registrations, :dependent => :destroy
  has_many :abstracts
  has_many :badges, -> { where("conference_registrations.status_name=?", APPROVED_STATUS) }, :through => :conference_registrations

  attr_accessible :name, :start_date, :finish_date, :registration_opened

  def self.available_conferences(already_subscribed)
    Conference.where(registration_opened: true).to_a - already_subscribed
  end

  def self.finished
    where("finish_date < ?", Time.now)
  end

  def to_s
    name
  end

  def loaded?
    true
  end
end
