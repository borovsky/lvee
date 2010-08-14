class Sponsor < ActiveRecord::Base
  file_column :image

  validates :name, :sponsor_type, :url, :image, :presence => true

  def self.list
    Sponsor.order("id").all.group_by(&:sponsor_type)
  end
end
