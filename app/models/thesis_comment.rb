class ThesisComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :thesis

  validates :user_id, :thesis_id, :body, :presence => true
end
