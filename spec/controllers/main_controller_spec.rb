require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MainController do
  integrate_views
  before :all do
    @user=stub(:id => 1, :editor? => false, :admin? => false, :login => "user", :full_name => "Vasily Pupkin")
    @editor=stub(:id => 2, :editor? => true, :admin? => false, :login => "user", :full_name => "Vasily Pupkin")
    @admin=stub(:id => 2, :editor? => true, :admin? => true, :login => "user", :full_name => "Vasily Pupkin")
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
end
