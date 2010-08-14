class Status < ActiveRecord::Base
  def self.available_statuses
    select(:name).order(:name).all.map {|s| s.name}
  end
end
