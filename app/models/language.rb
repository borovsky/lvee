class Language < ActiveRecord::Base
  set_primary_key :name
  validates_length_of :name, :is => 2, :allow_blank => false
  validates_length_of :code3, :is => 3, :allow_blank => false

  def self.published
    find(:all, :conditions => {:published => true}, :order => :name)
  end

  def self.published_names
    published.map{|l| l.id}
  end
end
