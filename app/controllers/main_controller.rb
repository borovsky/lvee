class MainController < ApplicationController
  SITEMAP_CATEGORIES = %w(conference reports sponsors contacts)

  def index
    @news = News.published.find(:all, :limit => 5)
  end

  def select_lang
    lang = preferred_language(Language.published_names)
    redirect_to :controller => "main", :action =>'index', :lang => lang
  end

  def sitemap
    @languages = Language.published_names
    @articles = Article.find_all_by_locale_and_category(I18n.default_locale, SITEMAP_CATEGORIES)
    @news = News.published.sitemap.translated(I18n.default_locale)
    render :template => "main/sitemap.rxml", :layout => false
  end

end
