class EditorLog < ActiveRecord::Base
  scope :last_private, where(:public => false).order("id desc").limit(100)
  scope :last_public, where(:public => true).order("id desc").limit(100)
end
