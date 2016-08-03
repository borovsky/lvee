module WikiPageConcern
  extend ActiveSupport::Concern
  include DiffHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper

  WIKI_PAGE_CREATED = "wiki_page_created"
  WIKI_PAGE_CHANGED = "wiki_page_changed"

  included do
    after_save :editor_log
  end

  def render_wiki_page(page)
    body = "<h1>#{page.name}</h1>"
    body << simple_format(h(page.body))
    body
  end

  def editor_log
    if(self.versions.size == 1)
      change_type = WIKI_PAGE_CREATED
    else
      change_type = WIKI_PAGE_CHANGED
    end
    object_name = self.name

    wiki_page = self.versions.last
    prev = wiki_page.previous
    body = display_diff(prev, wiki_page, :render_wiki_page, :rss)
    url = "wiki_pages/#{self.id}/diff/#{self.version}"
    user_name = self.user.full_name if self.user

    log = EditorLog.new(:change_type => change_type,
                        :body => body,
                        :url => url,
                        :user_name => user_name,
                        :object_name => object_name,
                        :public => true)
    log.save
  end
end
