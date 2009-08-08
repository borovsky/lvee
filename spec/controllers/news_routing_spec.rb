require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "news", :action => "index", :lang => 'ru').should == "/ru/news"
    end

    it "should map #new" do
      route_for(:controller => "news", :action => "new", :lang => 'ru').should == "/ru/news/new"
    end

    it "should map #new (translate mode)" do
      route_for(:controller => "news", :action => "new", :lang => 'ru', :parent_id => "5", :locale => "ru").should == "/ru/news/5/translate/ru"
    end

    it "should map #show" do
      route_for(:controller => "news", :action => "show", :id => "1", :lang => 'ru').should == "/ru/news/1"
    end

    it "should map #edit" do
      route_for(:controller => "news", :action => "edit", :id => "1", :lang => 'ru').should == "/ru/news/1/edit"
    end

    it "should map #publish" do
      route_for(:controller => "news", :action => "publish", :id => "1", :lang => 'ru').should == "/ru/news/1/publish"
    end

    it "should map #publish_now" do
      route_for(:controller => "news", :action => "publish_now", :id => "1", :lang => 'ru').should == "/ru/news/1/publish_now"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/ru/news").should == {:controller => "news", :action => "index", :lang => 'ru'}
    end

    it "should generate params for #new" do
      params_from(:get, "/ru/news/new").should == {:controller => "news", :action => "new", :lang => 'ru'}
    end

    it "should generate params for #new (translate)" do
      params_from(:get, "/ru/news/5/translate/ru").should == {:controller => "news", :action => "new", :lang => 'ru', :parent_id => "5", :locale => "ru"}
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

    it "should generate params for #publish" do
      params_from(:get, "/ru/news/1/publish").should == {:controller => "news", :action => "publish", :id => "1", :lang => 'ru'}
    end

    it "should generate params for #publish_now" do
      params_from(:get, "/ru/news/1/publish_now").should == {:controller => "news", :action => "publish_now", :id => "1", :lang => 'ru'}
    end
  end
end
