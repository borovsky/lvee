class Language < ActiveRecord::Base
  set_primary_key :name
  validates :name, :length => {:is => 2, :allow_blank => false}
  validates :code3, :length => {:is => 3, :allow_blank => false}

  def self.published
    find(:all, :conditions => {:published => true}, :order => :name)
  end

  def self.published_names
    published.map{|l| l.id}
  end
end
