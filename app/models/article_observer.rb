class ArticleObserver < ActiveRecord::Observer
  include DiffHelper

  ARTICLE_CREATED = "article_created"
  ARTICLE_CHANGED = "article_changed"

  def add_inline_style(text)
    text.gsub(/<del /, "<del style='#{DEL_STYLE}' ").
      gsub(/<ins /, "<ins style='#{INS_STYLE}' ")
  end

  def render_article(article)
    body = "<h1>#{h(article.title)}</h1>"
    body << textilize(article.body)
    body
  end

  def after_save(model)
    if(model.versions.size == 1)
      change_type = ARTICLE_CREATED
    else
      change_type = ARTICLE_CHANGED
    end
    object_name = "#{model.category}/#{model.name}"

    article = model.versions.last
    if(article)
      prev = article.previous
      body = add_inline_style(display_diff(prev, article, :render_article))
      url = "articles/#{model.id}/diff/#{model.version}"
      user_name = model.user.full_name if model.user

      log = EditorLog.new(:change_type => change_type, :body => body, :url => url,
        :user_name => user_name, :object_name => object_name, :public => false)
      log.save
    end
  end
end
