require 'acts_as_versioned'

class News < ActiveRecord::Base

  belongs_to :user

  attr_protected :user_id

  acts_as_versioned

  validates :title, :lead, :body, :presence => true

  validates :locale, :presence => true, :uniqueness => {:scope => :parent_id}, :if => Proc.new { |user| user.parent_id }

  scope :published, lambda { ||
    { :conditions => [
        "news.published_at IS NOT NULL AND news.published_at <= ?",
        Time.new ],
      :order => 'created_at DESC'
    }
  }

  scope :sitemap, lambda { ||
    { :conditions => [
        "news.published_at >= ?",
        3.days.ago ],
      :order => 'created_at DESC'
    }
  }

  def self.translated(locale = nil, params={})
    locale ||= I18n.locale
    news = []
    with_scope :find => params do
      news = find_all_by_parent_id(nil)
    end
    return news if locale == I18n.default_locale
    news.map { |n| n.translation(locale) }
  end

  def self.translation_for(news, locale)
    with_exclusive_scope do
      find_by_parent_id_and_locale(news.id, locale)
    end
  end

  def translation(locale=nil)
    locale ||= I18n.locale
    trans = News.translation_for(self, locale) || self
    trans.published_at = self.published_at
    trans
  end

  def translated?
    !(self.locale == I18n.default_locale)
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
