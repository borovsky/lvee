class AbstractComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :abstract

  validates :user_id, :abstract_id, :body, :presence => true

  attr_accessible :user_id, :body
end
