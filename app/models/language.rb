class Language < ActiveRecord::Base
  self.primary_key = :name
  validates :name, :length => {:is => 2, :allow_blank => false}, :uniqueness => true
  validates :code3, :length => {:is => 3, :allow_blank => false}

  has_many :translations

  scope :published, where(:published => true).order(:name)

  attr_accessible :name, :code3, :description, :published

  def self.published_names
    published.select(:name).map{|l| l.id}
  end
end
