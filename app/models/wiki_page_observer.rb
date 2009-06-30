class WikiPageObserver < ActiveRecord::Observer
  include DiffHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper

  WIKI_PAGE_CREATED = "wiki_page_created"
  WIKI_PAGE_CHANGED = "wiki_page_changed"

  def render_wiki_page(page)
    body = "<h1>#{page.name}</h1>"
    body << simple_format(h(page.body))
    body
  end

  def after_save(model)
    if(model.versions.size == 1)
      change_type = WIKI_PAGE_CREATED
    else
      change_type = WIKI_PAGE_CHANGED
    end
    object_name = model.name

    wiki_page = model.versions.last
    prev = wiki_page.previous
    body = display_diff(prev, wiki_page, :render_wiki_page, :rss)
    url = "wiki_pages/#{model.id}/diff/#{model.version}"
    user_name = model.user.full_name if model.user

    log = EditorLog.new(:change_type => change_type, :body => body, :url => url,
      :user_name => user_name, :object_name => object_name, :public => true)
    log.save
  rescue Exception => e
    puts e.message
    puts e.backtrace.join
  end
end
