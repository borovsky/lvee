require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MainController do
  describe "route recognition" do
    it "should generate params for #editor_rss" do
      {:get => "/be/main/editor_rss"}.should route_to(:controller => "main", :action => "editor_rss", :lang=>"be")
    end

    it "should generate params for #wiki_rss" do
      {:get => "/be/wiki_rss"}.should route_to(:controller => "main", :action => "wiki_rss", :lang=>"be")
    end

    it "should generate params for #sitemap" do
      {:get => "/be/sitemap.xml"}.should route_to(:controller => "main", :action => "sitemap", :format => "xml", :lang=>"be")
    end

    it "should generate params for #sitemap_news" do
      {:get => "/be/sitemap_news.xml"}.should route_to(:controller => "main", :action => "sitemap_news", :format => "xml", :lang=>"be")
    end
  end
end