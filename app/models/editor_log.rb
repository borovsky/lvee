class EditorLog < ActiveRecord::Base
  scope :last_private, where(:public => false).order("id desc").limit(100)
  scope :last_public, where(:public => true).order("id desc").limit(100)

  attr_accessible :url, :body, :user_name, :object_name, :change_type, :public
end
