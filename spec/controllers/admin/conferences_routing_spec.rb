require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::ConferencesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "admin/conferences", :action => "index", :lang => 'ru').should == "/ru/admin/conferences"
    end

    it "should map #new" do
      route_for(:controller => "admin/conferences", :action => "new", :lang => 'ru').should == "/ru/admin/conferences/new"
    end

    it "should map #show" do
      route_for(:controller => "admin/conferences", :action => "show", :id => 1, :lang => 'ru').should == "/ru/admin/conferences/1"
    end

    it "should map #edit" do
      route_for(:controller => "admin/conferences", :action => "edit", :id => 1, :lang => 'ru').should == "/ru/admin/conferences/1/edit"
    end

    it "should map #update" do
      route_for(:controller => "admin/conferences", :action => "update", :id => 1, :lang => 'ru').should == "/ru/admin/conferences/1"
    end

    it "should map #destroy" do
      route_for(:controller => "admin/conferences", :action => "destroy", :id => 1, :lang => 'ru').should == "/ru/admin/conferences/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/ru/admin/conferences").should == {:controller => "admin/conferences", :action => "index", :lang => 'ru'}
    end

    it "should generate params for #new" do
      params_from(:get, "/ru/admin/conferences/new").should == {:controller => "admin/conferences", :action => "new", :lang => 'ru'}
    end

    it "should generate params for #create" do
      params_from(:post, "/ru/admin/conferences").should == {:controller => "admin/conferences", :action => "create", :lang => 'ru'}
    end

    it "should generate params for #show" do
      params_from(:get, "/ru/admin/conferences/1").should == {:controller => "admin/conferences", :action => "show", :id => "1", :lang => 'ru'}
    end

    it "should generate params for #edit" do
      params_from(:get, "/ru/admin/conferences/1/edit").should == {:controller => "admin/conferences", :action => "edit", :id => "1", :lang => 'ru'}
    end

    it "should generate params for #update" do
      params_from(:put, "/ru/admin/conferences/1").should == {:controller => "admin/conferences", :action => "update", :id => "1", :lang => 'ru'}
    end

    it "should generate params for #destroy" do
      params_from(:delete, "/ru/admin/conferences/1").should == {:controller => "admin/conferences", :action => "destroy", :id => "1", :lang => 'ru'}
    end
  end
end
