require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsController do
  describe "route recognition" do
    it "should generate params for #index" do
      {:get => "/ru/news"}.should route_to(:controller => "news", :action => "index", :lang => 'ru')
    end

    it "should generate params for #new" do
      {:get => "/ru/news/new"}.should route_to(:controller => "news", :action => "new", :lang => 'ru')
    end

    it "should generate params for #new (translate)" do
      {:get => "/ru/news/5/translate/ru"}.should route_to(:controller => "news", :action => "new", :lang => 'ru', :parent_id => "5", :locale => "ru")
    end

    it "should generate params for #create" do
      {:post => "/ru/news"}.should route_to(:controller => "news", :action => "create", :lang => 'ru')
    end

    it "should generate params for #show" do
      {:get => "/ru/news/1"}.should route_to(:controller => "news", :action => "show", :id => "1", :lang => 'ru')
    end

    it "should generate params for #edit" do
      {:get => "/ru/news/1/edit"}.should route_to(:controller => "news", :action => "edit", :id => "1", :lang => 'ru')
    end

    it "should generate params for #update" do
      {:put => "/ru/news/1"}.should route_to(:controller => "news", :action => "update", :id => "1", :lang => 'ru')
    end

    it "should generate params for #destroy" do
      {:delete => "/ru/news/1"}.should route_to(:controller => "news", :action => "destroy", :id => "1", :lang => 'ru')
    end

    it "should generate params for #publish" do
      {:get => "/ru/news/1/publish"}.should route_to(:controller => "news", :action => "publish", :id => "1", :lang => 'ru')
    end

    it "should generate params for #publish_now" do
      {:get => "/ru/news/1/publish_now"}.should route_to(:controller => "news", :action => "publish_now", :id => "1", :lang => 'ru')
    end
  end
end
