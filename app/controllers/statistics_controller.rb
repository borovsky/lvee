class StatisticsController < ApplicationController
  def access
  end

  def conference
    @conference = Conference.find_by_name!(params[:id])
    @registrations = ConferenceRegistration.where(:conference_id => @conference).
      includes(:user).order("users.country ASC, users.city ASC, users.last_name ASC, users.first_name")

    @countries = @registrations.map {|i| [i.user.country, i.quantity]}. #fetch required fields
      group_by(&:first) #group by country
    @countries = @countries.map do |item|
      item[1] = item[1].map(&:second).inject{|sum, i| sum + i} #second to sum of quantities
      item
    end.sort_by(&:second).reverse # sort
  end
end
