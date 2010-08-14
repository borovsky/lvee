require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Editor::LanguagesController do

  def mock_language(stubs={})
    @mock_language ||= stub_model(Language, stubs)
  end

  before do
    @editor = stub_model(User, :id => 1, :role => "editor")
  end

  describe "responding to GET index" do

    it "should expose all languages as @languages" do
      login_as(@editor)
      Language.should_receive(:find).with(:all).and_return([mock_language])
      get :index
      assert_response :success
      assigns[:languages].should == [mock_language]
    end

    describe "with mime type of xml" do

      it "should render all languages as xml" do
        login_as(@editor)
        request.env["HTTP_ACCEPT"] = "application/xml"
        Language.should_receive(:find).with(:all).and_return(languages = mock("Array of Languages"))
        languages.should_receive(:to_xml).and_return("generated XML")
        get :index
        assert_response :success
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET show" do

    it "should expose the requested language as @language" do
      login_as(@editor)
      Language.should_receive(:find).with("37").and_return(mock_language)
      get :show, :id => "37"
      assert_response :success
      assigns[:language].should equal(mock_language)
    end

    describe "with mime type of xml" do

      it "should render the requested language as xml" do
        login_as(@editor)
        request.env["HTTP_ACCEPT"] = "application/xml"
        Language.should_receive(:find).with("37").and_return(mock_language)
        mock_language.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        assert_response :success
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET new" do

    it "should expose a new language as @language" do
      login_as(@editor)
      @mock = mock_language
      Language.should_receive(:new).and_return(@mock)
      get :new
      assert_response :success
      assigns[:language].should equal(@mock)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested language as @language" do
      login_as(@editor)
      Language.should_receive(:find).with("37").and_return(mock_language)
      get :edit, :id => "37"
      assert_response :success
      assigns[:language].should equal(mock_language)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created language as @language" do
        login_as(@editor)
        @mock = mock_language(:save => true, :name= => nil)
        Language.should_receive(:new).with({'these' => 'params'}).and_return(@mock)

        post :create, :language => {:these => 'params'}
        assigns(:language).should equal(@mock)
        assert_response :redirect
      end

      it "should redirect to the created language" do
        login_as(@editor)
        @mock = mock_language(:save => true, :name= => nil)
        Language.stub!(:new).and_return(@mock)
        post :create, :language => {}
        response.should redirect_to(editor_language_url(:id=>@mock))
      end

    end

    describe "with invalid params" do
      it "should expose a newly created but unsaved language as @language" do
        login_as(@editor)
        @mock = mock_language(:save => false, :name= => nil)
        Language.stub!(:new).with({'these' => 'params'}).and_return(@mock)
        post :create, :language => {:these => 'params'}
        assert_response :success
        assigns(:language).should equal(@mock)
      end

      it "should re-render the 'new' template" do
        login_as(@editor)
        @mock = mock_language(:save => false, :name= => nil)
        Language.stub!(:new).and_return(@mock)
        post :create, :language => {}
        assert_response :success
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT update" do

    describe "with valid params" do

      it "should update the requested language" do
        login_as(@editor)
        Language.should_receive(:find).with("37").and_return(mock_language)
        mock_language.should_receive(:update_attributes).with({'these' => 'params'})
        mock_language.should_receive(:name=)
        assert_response :success
        put :update, :id => "37", :language => {:these => 'params'}
      end

      it "should expose the requested language as @language" do
        login_as(@editor)
        Language.stub!(:find).and_return(mock_language(:update_attributes => true, :name= => nil))
        put :update, :id => "1"
        assert_response :redirect
        assigns(:language).should equal(mock_language)
      end

      it "should redirect to the language" do
        login_as(@editor)
        Language.stub!(:find).and_return(mock_language(:update_attributes => true, :name= => nil))
        put :update, :id => "1"
        response.should redirect_to(editor_language_url(:id=>mock_language))
      end

    end

    describe "with invalid params" do

      it "should update the requested language" do
        login_as(@editor)
        Language.should_receive(:find).with("37").and_return(mock_language)
        mock_language.should_receive(:update_attributes).with({'these' => 'params'})
        mock_language.should_receive(:name=)
        put :update, :id => "37", :language => {:these => 'params'}
        assert_response :success
      end

      it "should expose the language as @language" do
        login_as(@editor)
        Language.stub!(:find).and_return(mock_language(:update_attributes => false, :name= => nil))
        put :update, :id => "1"
        assert_response :success
        assigns(:language).should equal(mock_language)
      end

      it "should re-render the 'edit' template" do
        login_as(@editor)
        Language.stub!(:find).and_return(mock_language(:update_attributes => false, :name= => nil))
        put :update, :id => "1"
        assert_response :success
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested language" do
      login_as(@editor)
      Language.should_receive(:find).with("37").and_return(mock_language)
      mock_language.should_receive(:destroy)
      delete :destroy, :id => "37"
      assert_response :redirect
    end

    it "should redirect to the languages list" do
      login_as(@editor)
      Language.stub!(:find).and_return(mock_language(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(editor_languages_url)
    end

  end

  describe "responding to download" do
    it "should load english language" do
      login_as(@editor)
      mock_en = mock
      YAML.should_receive(:load_file).with("#{LOCALE_DIR}/en.yml").and_return({"en" => mock_en})
      File.should_receive(:exist?).with("#{LOCALE_DIR}/be.yml").and_return(false)
      mock_en.should_receive(:ya2yaml).and_return("some yaml")

      get :download, :id => "be", :format => "yml"
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

      get :download, :id => "be", :format => "yml"
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

      response.should redirect_to(editor_language_url(:id => 'be'))
    end
  end
end
