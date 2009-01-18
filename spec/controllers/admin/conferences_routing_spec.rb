require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::ConferencesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "admin/conferences", :action => "index").should == "/admin/conferences"
    end

    it "should map #new" do
      route_for(:controller => "admin/conferences", :action => "new").should == "/admin/conferences/new"
    end

    it "should map #show" do
      route_for(:controller => "admin/conferences", :action => "show", :id => 1).should == "/admin/conferences/1"
    end

    it "should map #edit" do
      route_for(:controller => "admin/conferences", :action => "edit", :id => 1).should == "/admin/conferences/1/edit"
    end

    it "should map #update" do
      route_for(:controller => "admin/conferences", :action => "update", :id => 1).should == "/admin/conferences/1"
    end

    it "should map #destroy" do
      route_for(:controller => "admin/conferences", :action => "destroy", :id => 1).should == "/admin/conferences/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/admin/conferences").should == {:controller => "admin/conferences", :action => "index"}
    end

    it "should generate params for #new" do
      params_from(:get, "/admin/conferences/new").should == {:controller => "admin/conferences", :action => "new"}
    end

    it "should generate params for #create" do
      params_from(:post, "/admin/conferences").should == {:controller => "admin/conferences", :action => "create"}
    end

    it "should generate params for #show" do
      params_from(:get, "/admin/conferences/1").should == {:controller => "admin/conferences", :action => "show", :id => "1"}
    end

    it "should generate params for #edit" do
      params_from(:get, "/admin/conferences/1/edit").should == {:controller => "admin/conferences", :action => "edit", :id => "1"}
    end

    it "should generate params for #update" do
      params_from(:put, "/admin/conferences/1").should == {:controller => "admin/conferences", :action => "update", :id => "1"}
    end

    it "should generate params for #destroy" do
      params_from(:delete, "/admin/conferences/1").should == {:controller => "admin/conferences", :action => "destroy", :id => "1"}
    end
  end
end
