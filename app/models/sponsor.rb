class Sponsor < ActiveRecord::Base
  file_column :image

  validates_presence_of :name, :type, :url, :image

  def self.list
    list = {}

    Sponsor.find(:all, :order => "id").each do |s|
      list[s.sponsor_type] ||= []
      list[s.sponsor_type] << s
    end

    list
  end
end
