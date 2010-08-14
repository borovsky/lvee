require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Editor::LanguagesController do
  if false
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "editor/languages", :action => "index", :lang=>'ru').should == "/ru/editor/languages"
    end

    it "should map #new" do
      route_for(:controller => "editor/languages", :action => "new", :lang=>'ru').should == "/ru/editor/languages/new"
    end

    it "should map #show" do
      route_for(:controller => "editor/languages", :action => "show", :id => "1", :lang=>'ru').should == "/ru/editor/languages/1"
    end

    it "should map #edit" do
      route_for(:controller => "editor/languages", :action => "edit", :id => "1", :lang=>'ru').should == "/ru/editor/languages/1/edit"
    end
  end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      {:get => "/ru/editor/languages"}.should route_to(:controller => "editor/languages", :action => "index", :lang=>'ru')
    end

    it "should generate params for #new" do
      {:get => "/ru/editor/languages/new"}.should route_to(:controller => "editor/languages", :action => "new", :lang=>'ru')
    end

    it "should generate params for #create" do
      {:post => "/ru/editor/languages"}.should route_to(:controller => "editor/languages", :action => "create", :lang=>'ru')
    end

    it "should generate params for #show" do
      {:get => "/ru/editor/languages/1"}.should route_to(:controller => "editor/languages", :action => "show", :id => "1", :lang=>'ru')
    end

    it "should generate params for #edit" do
      {:get => "/ru/editor/languages/1/edit"}.should route_to(:controller => "editor/languages", :action => "edit", :id => "1", :lang=>'ru')
    end

    it "should generate params for #update" do
      {:put => "/ru/editor/languages/1"}.should route_to(:controller => "editor/languages", :action => "update", :id => "1", :lang=>'ru')
    end

    it "should generate params for #destroy" do
      {:delete => "/ru/editor/languages/1"}.should route_to(:controller => "editor/languages", :action => "destroy", :id => "1", :lang=>'ru')
    end
  end
end
