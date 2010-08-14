class Sponsor < ActiveRecord::Base
  file_column :image

  validates :name, :sponsor_type, :url, :image, :presence => true

  def self.list
    list = {}

    Sponsor.find(:all, :order => "id").each do |s|
      list[s.sponsor_type] ||= []
      list[s.sponsor_type] << s
    end

    list
  end
end
