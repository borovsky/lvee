class AbstractComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :abstract

  validates :user_id, :thesis_id, :body, :presence => true
end
