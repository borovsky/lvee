require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArticlesController do
  describe "route recognition" do
    it "should generate params for #index" do
      {:get => "/be/articles"}.should route_to(:controller => "articles", :action => "index", :lang=>"be")
    end

    it "should generate params for #new" do
      {:get => "/be/articles/new"}.should route_to(:controller => "articles", :action => "new", :lang=>"be")
    end

    it "should generate params for #create" do
      {:post => "/be/articles"}.should route_to(:controller => "articles", :action => "create", :lang=>"be")
    end

    it "should generate params for #show" do
      {:get => "/be/articles/1"}.should route_to(:controller => "articles", :action => "show", :id => "1", :lang=>"be")
    end

    it "should generate params for #edit" do
      {:get => "/be/articles/1/edit"}.should route_to(:controller => "articles", :action => "edit", :id => "1", :lang=>"be")
    end

    it "should generate params for #update" do
      {:put => "/be/articles/1"}.should route_to(:controller => "articles", :action => "update", :id => "1", :lang=>"be")
    end

    it "should generate params for #destroy" do
      {:delete => "/be/articles/1"}.should route_to(:controller => "articles", :action => "destroy", :id => "1", :lang=>"be")
    end
  end
end
