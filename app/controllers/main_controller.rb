class MainController < ApplicationController
  SITEMAP_CATEGORIES = %w(conference reports sponsors contacts)

  def index
    @news = News.published
  end

  def select_lang
    lang = preferred_language(Language.published_names)
    redirect_to main_page_path(lang)
  end

  def sitemap
    @languages = Language.published_names
    @articles = Article.find_all_by_locale_and_category(I18n.default_locale, SITEMAP_CATEGORIES)
    @news = News.published.sitemap.translated(I18n.default_locale)
    render :template => "main/sitemap.rxml", :layout => false
  end

  def sitemap_news
    @languages = Language.published_names
    @news = News.published.sitemap.translated(I18n.default_locale)
    render :template => "main/sitemap_news.rxml", :layout => false
  end

  def editor_rss
    @changes = EditorLog.last_private
    render :action => 'editor_rss', :layout => false
  end

  def wiki_rss
    @changes = EditorLog.last_public
    render :action => 'wiki_rss', :layout => false
  end
end
