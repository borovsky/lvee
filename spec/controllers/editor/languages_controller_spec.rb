require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

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

  describe "responding to show YML" do
    it "should load english language" do
      login_as(@editor)
      mock_en = mock
      YAML.should_receive(:load_file).with("#{LOCALE_DIR}/en.yml").and_return({"en" => mock_en})
      File.should_receive(:exist?).with("#{LOCALE_DIR}/be.yml").and_return(false)
      mock_en.should_receive(:ya2yaml).and_return("some yaml")

      get :show, :id => "be", :format => "yml"
      assert_response :success
      response.body.should == "some yaml"
    end

    it "should load english language" do
      login_as(@editor)
      mock_en = mock
      mock_be = mock
      common_mock = mock

      YAML.should_receive(:load_file).with("#{LOCALE_DIR}/en.yml").and_return({"en" => mock_en})
      File.should_receive(:exist?).with("#{LOCALE_DIR}/be.yml").and_return(true)
      YAML.should_receive(:load_file).with("#{LOCALE_DIR}/be.yml").and_return({"be" => mock_be})
      mock_en.should_receive(:deep_merge).with(mock_be).and_return(common_mock)

      common_mock.should_receive(:ya2yaml).and_return("some yaml")

      get :show, :id => "be", :format => "yml"
      assert_response :success
      response.body.should == "some yaml"
    end
  end

  describe "responding to upload" do
    it "should merge uploaded language with en" do
      login_as(@editor)

      mock_en = mock
      mock_up = mock
      trans = mock
      translation = mock
      
      lang = mock
      Language.should_receive(:find).with('be').and_return(lang)

      YAML.should_receive(:load_file).with("#{LOCALE_DIR}/en.yml").and_return({"en" => mock_en})
      mock_up.should_receive(:read).and_return(trans)

      YAML.should_receive(:load).with(trans).and_return(translation)
      mock_en.should_receive(:deep_merge).with(translation).and_return("merged")

      mock_file = mock
      mock_file.should_receive(:write).with({'be' => "merged"}.ya2yaml)

      File.should_receive(:open).with("#{LOCALE_DIR}/be.yml", "w").and_yield(mock_file)

      get :upload, :id => "be", :language => mock_up

      response.should redirect_to(editor_languages_url(:id => 'be'))
    end
  end
end
