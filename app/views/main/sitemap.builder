xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc         "http://lvee.org"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
  end
  @languages.each do |language|
    @news.each do |news_item|
      xml.url do
        xml.loc         news_item_url(lang: language, id: news_item)
        xml.lastmod     w3c_date(news_item.updated_at)
        xml.changefreq  "monthly"
      end
    end
    @articles.each do |article|
      xml.url do
        xml.loc         url_for(lang: language, category: article.category, 
          name: article.name, controller: "/articles", action: 'show', only_path: false)
        xml.lastmod     w3c_date(article.updated_at)
        xml.changefreq  "weekly"
      end
    end
    @abstracts.each do |abstract|
      xml.url do
        xml.loc         abstract_url(abstract, lang: language)
        xml.lastmod     w3c_date(abstract.updated_at)
        xml.changefreq  "monthly"
      end
    end
  end
end
