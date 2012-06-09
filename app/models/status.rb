class Status < ActiveRecord::Base
  attr_accessible :name, :subject, :mail

  def self.available_statuses
    select(:name).order(:name).all.map {|s| s.name}
  end
end
