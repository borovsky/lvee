require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArticlesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "articles", :action => "index", :lang=>"be").should == "/be/articles"
    end

    it "should map #new" do
      route_for(:controller => "articles", :action => "new", :lang=>"be").should == "/be/articles/new"
    end

    it "should map #show" do
      route_for(:controller => "articles", :action => "show", :id => "1", :lang=>"be").should == "/be/articles/1"
    end

    it "should map #edit" do
      route_for(:controller => "articles", :action => "edit", :id => "1", :lang=>"be").should == "/be/articles/1/edit"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/be/articles").should == {:controller => "articles", :action => "index", :lang=>"be"}
    end

    it "should generate params for #new" do
      params_from(:get, "/be/articles/new").should == {:controller => "articles", :action => "new", :lang=>"be"}
    end

    it "should generate params for #create" do
      params_from(:post, "/be/articles").should == {:controller => "articles", :action => "create", :lang=>"be"}
    end

    it "should generate params for #show" do
      params_from(:get, "/be/articles/1").should == {:controller => "articles", :action => "show", :id => "1", :lang=>"be"}
    end

    it "should generate params for #edit" do
      params_from(:get, "/be/articles/1/edit").should == {:controller => "articles", :action => "edit", :id => "1", :lang=>"be"}
    end

    it "should generate params for #update" do
      params_from(:put, "/be/articles/1").should == {:controller => "articles", :action => "update", :id => "1", :lang=>"be"}
    end

    it "should generate params for #destroy" do
      params_from(:delete, "/be/articles/1").should == {:controller => "articles", :action => "destroy", :id => "1", :lang=>"be"}
    end
  end
end
