require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WikiPagesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "wiki_pages", :action => "index", :lang=>"be").should == "/be/wiki_pages"
    end

    it "should map #new" do
      route_for(:controller => "wiki_pages", :action => "new", :lang=>"be").should == "/be/wiki_pages/new"
    end

    it "should map #show" do
      route_for(:controller => "wiki_pages", :action => "show", :id => "1", :lang=>"be").should == "/be/wiki_pages/1"
    end

    it "should map #edit" do
      route_for(:controller => "wiki_pages", :action => "edit", :id => "1", :lang=>"be").should == "/be/wiki_pages/1/edit"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/be/wiki_pages").should == {:controller => "wiki_pages", :action => "index", :lang=>"be"}
    end

    it "should generate params for #new" do
      params_from(:get, "/be/wiki_pages/new").should == {:controller => "wiki_pages", :action => "new", :lang=>"be"}
    end

    it "should generate params for #create" do
      params_from(:post, "/be/wiki_pages").should == {:controller => "wiki_pages", :action => "create", :lang=>"be"}
    end

    it "should generate params for #show" do
      params_from(:get, "/be/wiki_pages/1").should == {:controller => "wiki_pages", :action => "show", :id => "1", :lang=>"be"}
    end

    it "should generate params for #edit" do
      params_from(:get, "/be/wiki_pages/1/edit").should == {:controller => "wiki_pages", :action => "edit", :id => "1", :lang=>"be"}
    end

    it "should generate params for #update" do
      params_from(:put, "/be/wiki_pages/1").should == {:controller => "wiki_pages", :action => "update", :id => "1", :lang=>"be"}
    end

    it "should generate params for #destroy" do
      params_from(:delete, "/be/wiki_pages/1").should == {:controller => "wiki_pages", :action => "destroy", :id => "1", :lang=>"be"}
    end
  end
end
