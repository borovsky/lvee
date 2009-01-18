require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "news", :action => "index").should == "/news"
    end
  
    it "should map #new" do
      route_for(:controller => "news", :action => "new").should == "/news/new"
    end
  
    it "should map #show" do
      route_for(:controller => "news", :action => "show", :id => 1).should == "/news/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "news", :action => "edit", :id => 1).should == "/news/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "news", :action => "update", :id => 1).should == "/news/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "news", :action => "destroy", :id => 1).should == "/news/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/news").should == {:controller => "news", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/news/new").should == {:controller => "news", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/news").should == {:controller => "news", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/news/1").should == {:controller => "news", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/news/1/edit").should == {:controller => "news", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/news/1").should == {:controller => "news", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/news/1").should == {:controller => "news", :action => "destroy", :id => "1"}
    end
  end
end
