class StatisticsController < ApplicationController
  def index
  end

  def conference
    @conference = Conference.find_by_name!(params[:id])
    @registrations = ConferenceRegistration.find(:all,
      :conditions => {:conference_id => @conference},
      :include => [:user],
      :order => "users.country ASC, users.city ASC, users.last_name ASC, users.first_name")

    @countries = @registrations.map(&:user).group_by(&:country).
      sort_by{|item| -item.second.length}
  end
end
