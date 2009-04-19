require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Editor::LanguagesController do

  def mock_language(stubs={})
    @mock_language ||= model_stub(Language, stubs)
  end

  before(:all) do
    @editor = stub(:id => 1, :editor? => true)
  end

  describe "responding to GET index" do

    it "should expose all languages as @languages" do
      login_as(@editor)
      Language.expects(:find).with(:all).returns([mock_language])
      get :index
      assigns[:languages].should == [mock_language]
    end

    describe "with mime type of xml" do

      it "should render all languages as xml" do
        login_as(@editor)
        request.env["HTTP_ACCEPT"] = "application/xml"
        Language.expects(:find).with(:all).returns(languages = mock("Array of Languages"))
        languages.expects(:to_xml).returns("generated XML")
        get :index
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET show" do

    it "should expose the requested language as @language" do
      login_as(@editor)
      Language.expects(:find).with("37").returns(mock_language)
      get :show, :id => "37"
      assigns[:language].should equal(mock_language)
    end

    describe "with mime type of xml" do

      it "should render the requested language as xml" do
        login_as(@editor)
        request.env["HTTP_ACCEPT"] = "application/xml"
        Language.expects(:find).with("37").returns(mock_language)
        mock_language.expects(:to_xml).returns("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET new" do

    it "should expose a new language as @language" do
      login_as(@editor)
      Language.expects(:new).returns(mock_language)
      get :new
      assigns[:language].should equal(mock_language)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested language as @language" do
      login_as(@editor)
      Language.expects(:find).with("37").returns(mock_language)
      get :edit, :id => "37"
      assigns[:language].should equal(mock_language)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created language as @language" do
        login_as(@editor)
        Language.expects(:new).with({'these' => 'params'}).returns(mock_language(:save => true, :name= => nil))

        post :create, :language => {:these => 'params'}
        assigns(:language).should equal(mock_language)
      end

      it "should redirect to the created language" do
        login_as(@editor)
        Language.stubs(:new).returns(mock_language(:save => true, :name= => nil))
        post :create, :language => {}
        response.should redirect_to(editor_language_url(:id=>mock_language))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved language as @language" do
        login_as(@editor)
        Language.stubs(:new).with({'these' => 'params'}).returns(mock_language(:save => false, :name= => nil))
        post :create, :language => {:these => 'params'}
        assigns(:language).should equal(mock_language)
      end

      it "should re-render the 'new' template" do
        login_as(@editor)
        Language.stubs(:new).returns(mock_language(:save => false, :name= => nil))
        post :create, :language => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT update" do

    describe "with valid params" do

      it "should update the requested language" do
        login_as(@editor)
        Language.expects(:find).with("37").returns(mock_language)
        mock_language.expects(:update_attributes).with({'these' => 'params'})
        mock_language.expects(:name=)
        put :update, :id => "37", :language => {:these => 'params'}
      end

      it "should expose the requested language as @language" do
        login_as(@editor)
        Language.stubs(:find).returns(mock_language(:update_attributes => true, :name= => nil))
        put :update, :id => "1"
        assigns(:language).should equal(mock_language)
      end

      it "should redirect to the language" do
        login_as(@editor)
        Language.stubs(:find).returns(mock_language(:update_attributes => true, :name= => nil))
        put :update, :id => "1"
        response.should redirect_to(editor_language_url(:id=>mock_language))
      end

    end

    describe "with invalid params" do

      it "should update the requested language" do
        login_as(@editor)
        Language.expects(:find).with("37").returns(mock_language)
        mock_language.expects(:update_attributes).with({'these' => 'params'})
        mock_language.expects(:name=)
        put :update, :id => "37", :language => {:these => 'params'}
      end

      it "should expose the language as @language" do
        login_as(@editor)
        Language.stubs(:find).returns(mock_language(:update_attributes => false, :name= => nil))
        put :update, :id => "1"
        assigns(:language).should equal(mock_language)
      end

      it "should re-render the 'edit' template" do
        login_as(@editor)
        Language.stubs(:find).returns(mock_language(:update_attributes => false, :name= => nil))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested language" do
      login_as(@editor)
      Language.expects(:find).with("37").returns(mock_language)
      mock_language.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the languages list" do
      login_as(@editor)
      Language.stubs(:find).returns(mock_language(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(editor_languages_url)
    end

  end

  describe "responding to download" do
    it "should load english language" do
      login_as(@editor)
      mock_en = mock
      YAML.expects(:load_file).with("#{LOCALE_DIR}/en.yml").returns({"en" => mock_en})
      File.expects(:exist?).with("#{LOCALE_DIR}/be.yml").returns(false)
      mock_en.expects(:ya2yaml).returns("some yaml")

      get :download, :id => "be", :format => "yml"

      response.body.should == "some yaml"
    end

    it "should load english language" do
      login_as(@editor)
      mock_en = mock
      mock_be = mock
      common_mock = mock

      YAML.expects(:load_file).with("#{LOCALE_DIR}/en.yml").returns({"en" => mock_en})
      File.expects(:exist?).with("#{LOCALE_DIR}/be.yml").returns(true)
      YAML.expects(:load_file).with("#{LOCALE_DIR}/be.yml").returns({"be" => mock_be})
      mock_en.expects(:deep_merge).with(mock_be).returns(common_mock)

      common_mock.expects(:ya2yaml).returns("some yaml")

      get :download, :id => "be", :format => "yml"
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
      Language.expects(:find).with('be').returns(lang)

      YAML.expects(:load_file).with("#{LOCALE_DIR}/en.yml").returns({"en" => mock_en})
      mock_up.expects(:read).returns(trans)

      YAML.expects(:load).with(trans).returns(translation)
      mock_en.expects(:deep_merge).with(translation).returns("merged")

      mock_file = mock
      mock_file.expects(:write).with({'be' => "merged"}.ya2yaml)

      File.expects(:open).with("#{LOCALE_DIR}/be.yml", "w").yields(mock_file)

      get :upload, :id => "be", :language => mock_up

      response.should redirect_to(editor_language_url(:id => 'be'))
    end
  end
end
