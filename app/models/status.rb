class Status < ActiveRecord::Base
  def self.available_statuses
    find(:all).map {|s| s.name}.sort
  end
end
