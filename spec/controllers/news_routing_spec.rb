require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "news", :action => "index", :lang => 'ru').should == "/ru/news"
    end

    it "should map #new" do
      route_for(:controller => "news", :action => "new", :lang => 'ru').should == "/ru/news/new"
    end

    it "should map #show" do
      route_for(:controller => "news", :action => "show", :id => 1, :lang => 'ru').should == "/ru/news/1"
    end

    it "should map #edit" do
      route_for(:controller => "news", :action => "edit", :id => 1, :lang => 'ru').should == "/ru/news/1/edit"
    end

    it "should map #update" do
      route_for(:controller => "news", :action => "update", :id => 1, :lang => 'ru').should == "/ru/news/1"
    end

    it "should map #destroy" do
      route_for(:controller => "news", :action => "destroy", :id => 1, :lang => 'ru').should == "/ru/news/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/ru/news").should == {:controller => "news", :action => "index", :lang => 'ru'}
    end

    it "should generate params for #new" do
      params_from(:get, "/ru/news/new").should == {:controller => "news", :action => "new", :lang => 'ru'}
    end

    it "should generate params for #create" do
      params_from(:post, "/ru/news").should == {:controller => "news", :action => "create", :lang => 'ru'}
    end

    it "should generate params for #show" do
      params_from(:get, "/ru/news/1").should == {:controller => "news", :action => "show", :id => "1", :lang => 'ru'}
    end

    it "should generate params for #edit" do
      params_from(:get, "/ru/news/1/edit").should == {:controller => "news", :action => "edit", :id => "1", :lang => 'ru'}
    end

    it "should generate params for #update" do
      params_from(:put, "/ru/news/1").should == {:controller => "news", :action => "update", :id => "1", :lang => 'ru'}
    end

    it "should generate params for #destroy" do
      params_from(:delete, "/ru/news/1").should == {:controller => "news", :action => "destroy", :id => "1", :lang => 'ru'}
    end
  end
end
