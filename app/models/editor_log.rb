class EditorLog < ActiveRecord::Base
  def self.last_private
    find(:all, :limit => 100, :order => "id desc", :conditions => {:public => false})
  end

  def self.last_public
    find(:all, :limit => 100, :order => "id desc", :conditions => {:public => true})
  end
end
