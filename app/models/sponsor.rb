class Sponsor < ActiveRecord::Base
  mount_uploader :image, SponsorUploader

  validates :name, :sponsor_type, :url, :image, :presence => true

  def self.list
    Sponsor.order("id").all.group_by(&:sponsor_type)
  end
end
