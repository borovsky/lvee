class Metainfo < ActiveRecord::Base
  attr_accessible :language, :page, :description, :keywords
  validates :language, :presence => true
  validates :page, :presence => true, :uniqueness => {:scope => :language}

  def self.for(lang, page)
    metainfo = Metainfo.where("language = ? AND page = ?", lang, page).take ||
      Metainfo.where("language = ? AND page = ?", I18n.default_locale, page).take ||
      Metainfo.new()
    metainfo.page = page
    metainfo.language = lang
    metainfo
  end

  def page_hex
    Digest::SHA1.hexdigest(self.page)
  end
end
