class Language < ActiveRecord::Base
  set_primary_key :name

  def self.published
    find(:all, :conditions => {:published => true}, :order => :name)
  end

  def self.published_names
    published.map{|l| l.id}
  end
end
