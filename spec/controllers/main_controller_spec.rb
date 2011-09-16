require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MainController do
  render_views
  before :all do
    @user = stub_model(User, :id => 1, :role => "", :login => "user", :full_name => "Vasily Pupkin")
    @editor = stub_model(User, :id => 2, :role => "editor", :login => "user", :full_name => "Vasily Pupkin")
    @admin = stub_model(User, :id => 2, :role => "admin", :login => "user", :full_name => "Vasily Pupkin")
  end

  describe "index should render" do
    it "for guest" do
      get :index
    end

    it "for user" do
      login_as @user
      get :index
    end

    it "for editor" do
      login_as @editor
      get :index
    end

    it "for admin" do
      login_as @editor
      get :index
    end
  end

  describe "editor_rss" do
    it "it should render" do
      get :editor_rss
    end
  end

  describe "wiki_rss" do
    it "it should render" do
      get :wiki_rss
    end
  end

  describe "sitemap" do
    it "it should render" do
      get :sitemap
    end
  end

  describe "sitemap_news" do
    it "it should render" do
      get :sitemap_news
    end
  end
end
