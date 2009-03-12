class Conference < ActiveRecord::Base
  has_many :conference_registrations, :dependent => :delete_all

  def self.available_conferences(already_subscribed)
    Conference.find_all_by_registration_opened(true) - already_subscribed
  end

  def to_s
    name
  end
end
