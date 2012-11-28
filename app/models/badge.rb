class Badge < ActiveRecord::Base
  attr_accessible :top, :bottom

  belongs_to :conference_registration
end
