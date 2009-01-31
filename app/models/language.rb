class Language < ActiveRecord::Base
  set_primary_key :name

  def self.published
    find(:all, :conditions => {:published => true}, :order => :name)
  end
end
