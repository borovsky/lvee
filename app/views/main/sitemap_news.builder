xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9",
  "xmlns:news" => "http://www.google.com/schemas/sitemap-news/0.9" do
  @languages.each do |language|
    @news.each do |news_item|
      xml.url do
        xml.loc         news_item_url(:lang=> language, :id => news_item)
        xml.lastmod     w3c_date(news_item.updated_at)
        xml.changefreq  "monthly"
        xml.news :news do
          xml.news :publication do
            xml.news :name, news_item.title
            xml.news :language, news_item.locale
          end
          xml.news :publication_date, w3c_date(news_item.created_at)
          xml.news :keywords, "Linux,LVEE,conference,Open Source,Free Software"
        end
      end
    end
  end
end
