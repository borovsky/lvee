class News < ActiveRecord::Base

  belongs_to :user

  attr_protected :user_id

  acts_as_versioned

  validates :title, :lead, :body, :presence => true

  validates :locale, :presence => true, :uniqueness => {:scope => :parent_id}, :if => Proc.new { |user| user.parent_id }

  scope :published, lambda {
    where("news.published_at IS NOT NULL AND news.published_at <= ?", Time.new)
  }

  scope :sitemap, -> {  }

  default_scope { order(created_at: :desc) }

  attr_accessible :title, :body, :category, :name, :locale, :lead, :parent_id

  def self.translated(locale = nil, params={})
    locale ||= I18n.locale
    news = where(parent_id: nil).to_a
    return news if locale == I18n.default_locale
    news.map { |n| n.translation(locale) }
  end

  def self.translation_for(news, locale)
      unscoped.where("id = ? OR parent_id = ?", news, news).where("locale = ?", locale).take
  end

  def translation(locale=nil)
    locale ||= I18n.locale
    trans = News.translation_for(self, locale) || self
    trans.published_at = self.published_at
    trans
  end

  def translated?
    !(self.locale.to_s == I18n.default_locale.to_s)
  end

  def publish
    self.published_at = Time.now + 1.day
    save
  end

  def publish_now
    self.published_at = Time.now
    save
  end

  def published?
    published_at && published_at <= Time.now
  end

end
