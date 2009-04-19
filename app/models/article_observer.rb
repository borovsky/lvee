class ArticleObserver < ActiveRecord::Observer
  include ArticlesHelper

  ARTICLE_CREATED = "article_created"
  ARTICLE_CHANGED = "article_changed"

  def add_inline_style(text)
    text.gsub(/<del /, "<del style='#{DEL_STYLE}' ").
      gsub(/<ins /, "<ins style='#{INS_STYLE}' ")
  end

  def after_save(model)
    if(model.versions.size == 1)
      type = ARTICLE_CREATED
    else
      type = ARTICLE_CHANGED
    end
    object_name = "#{model.category}/#{model.name}"

    article = model.versions.last
    prev = article.previous
    body = add_inline_style(display_diff(prev, article))
    url = "articles/#{model.id}/diff/#{model.version}"
    user_name = model.user.full_name if model.user

    log = EditorLog.new(:change_type => type, :body => body, :url => url,
      :user_name => user_name, :object_name => object_name)
    log.save
  end
end
