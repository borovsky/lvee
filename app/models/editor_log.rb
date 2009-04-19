class EditorLog < ActiveRecord::Base
  def self.last
    find(:all, :limit => 100, :order => "id desc")
  end
end
