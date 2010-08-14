class Language < ActiveRecord::Base
  set_primary_key :name
  validates :name, :length => {:is => 2, :allow_blank => false}
  validates :code3, :length => {:is => 3, :allow_blank => false}

  scope :published, where(:published => true).order(:name)

  def self.published_names
    published.select(:name).map{|l| l.id}
  end
end
