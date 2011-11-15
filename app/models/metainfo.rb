class Metainfo < ActiveRecord::Base
  validates :language, :presence => true
  validates :page, :presence => true, :uniqueness => {:scope => :language}

  def self.for(lang, page)
    metainfo = Metainfo.find_by_language_and_page(lang, page) ||
      Metainfo.find_by_language_and_page(I18n.default_locale, page) ||
      Metainfo.new()
    metainfo.page = page
    metainfo.language = lang
    metainfo
  end

  def page_hex
    Digest::SHA1.hexdigest(self.page)
  end
end
