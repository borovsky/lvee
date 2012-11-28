class Article < ActiveRecord::Base
  belongs_to :user
  acts_as_versioned

  validates :title, :body, :category, :name, :presence => true
  validates :locale, :presence => true, :uniqueness => {:scope => [:category, :name]}

  attr_accessible :name, :category, :title, :body, :locale

  def self.translated(locale = nil, params={})
    locale ||= I18n.locale
    articles = []
    with_scope :find => params do
      articles = where("locale = ?", I18n.default_locale).order("category, name")
    end
    return articles if locale == I18n.default_locale
    articles.map { |a| a.translation(locale) }
  end

  def self.translation_for(article, locale)
    with_exclusive_scope do
      find_by_category_and_name_and_locale(article.category, article.name, locale)
    end
  end

  def translation(locale=nil)
    locale ||= I18n.locale
    trans = Article.translation_for(self, locale) || self
    trans
  end

  def translated?
    !(self.locale.to_s == I18n.default_locale.to_s)
  end

  def self.load_by_name(category, name)
    return nil unless category and name

    find_by_category_and_name_and_locale(category, name, I18n.locale) ||
    find_by_category_and_name_and_locale(category, name, I18n.default_locale) ||
    find_by_category_and_name(category, name)
  end

  def self.load_by_name_or_create(category, name)
    return nil unless category and name
    a = load_by_name(category, name)
    return a if a
    Article.create!(:name => name, :category => category,
                      :title => name.camelize, :body => "Some body for #{name}",
                      :locale => I18n.default_locale)
  end

  def self.find_version(id, version)
    Version.where(:article_id => id, :version => version).first
  end

  def find_version(version)
    Article.find_version(self.id, version)
  end
end
