xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0") do
  xml.channel do
    xml.title("LVEE site news")
    xml.link("http://lvee.org/")
    xml.description("LVEE conference")
    xml.language(I18n.locale)
    for news in @news
      xml.item do
        xml.title(news.title)
        xml.description(textilize(news.lead))
        xml.author(news.user.full_name)
        xml.pubDate(news.published_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.link(news_item_url(:id => news.id))
        xml.guid(news_item_url(:id => news.id))
      end
    end
  end
end
