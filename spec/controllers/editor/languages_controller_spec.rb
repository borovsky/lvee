require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'stringio'

describe Editor::LanguagesController do

  def mock_language(stubs={})
    @mock_language ||= stub_model(Language, stubs)
  end

  before do
    @editor = stub_model(User, :id => 1, :role => "editor")
    @eng = Language.create!(:name => "en", :code3 => "eng", :description => "English", :published => true)

  end

  describe "responding to GET index" do

    it "should work" do
      login_as(@editor)
      get :index
      assert_response :success
    end
  end

  describe "responding to GET show" do

    it "should work" do
      login_as(@editor)
      get :show, :id => @eng.id
      assert_response :success
    end
  end

  describe "responding to GET new" do
    it "should return page" do
      login_as(@editor)
      get :new
      assert_response :success
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested language as @language" do
      login_as(@editor)
      get :edit, :id => @eng.id
      assert_response :success
    end
  end
end
