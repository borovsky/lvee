require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WikiPagesController do
  describe "route recognition" do
    it "should generate params for #index" do
      {:get => "/be/wiki_pages"}.should route_to(:controller => "wiki_pages", :action => "index", :lang=>"be")
    end

    it "should generate params for #new" do
      {:get => "/be/wiki_pages/new"}.should route_to(:controller => "wiki_pages", :action => "new", :lang=>"be")
    end

    it "should generate params for #create" do
      {:post => "/be/wiki_pages"}.should route_to(:controller => "wiki_pages", :action => "create", :lang=>"be")
    end

    it "should generate params for #show" do
      {:get => "/be/wiki_pages/1"}.should route_to(:controller => "wiki_pages", :action => "show", :id => "1", :lang=>"be")
    end

    it "should generate params for #edit" do
      {:get => "/be/wiki_pages/1/edit"}.should route_to(:controller => "wiki_pages", :action => "edit", :id => "1", :lang=>"be")
    end

    it "should generate params for #update" do
      {:put => "/be/wiki_pages/1"}.should route_to(:controller => "wiki_pages", :action => "update", :id => "1", :lang=>"be")
    end

    it "should generate params for #destroy" do
      {:delete => "/be/wiki_pages/1"}.should route_to(:controller => "wiki_pages", :action => "destroy", :id => "1", :lang=>"be")
    end
  end
end
