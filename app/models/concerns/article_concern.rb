module ArticleConcern
  extend ActiveSupport::Concern
  include DiffHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper

  ARTICLE_CREATED = "article_created"
  ARTICLE_CHANGED = "article_changed"

  included do
    after_save :editor_log
  end

  def render_article(article)
    body = "<h1>#{h(article.title)}</h1>"
    body << simple_format(h(article.body), {}, :sanitize => false)
    body
  end

  def editor_log
    if(self.versions.size == 1)
      change_type = ARTICLE_CREATED
    else
      change_type = ARTICLE_CHANGED
    end
    object_name = "#{self.category}/#{self.name}"

    article = self.versions.last
    prev = article.previous
    body = display_diff(prev, article, :render_article, :rss)
    url = "articles/#{self.id}/diff/#{self.version}"
    user_name = self.user.full_name if self.user

    log = EditorLog.new(:change_type => change_type,
                        :body => body,
                        :url => url,
                        :user_name => user_name,
                        :object_name => object_name,
                        :public => false)
    log.save
  end
end
