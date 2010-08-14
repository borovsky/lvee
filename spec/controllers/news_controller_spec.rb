require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsController do

  def mock_news(stubs={})
    @mock_news ||= stub_model(News, stubs)
  end

  before do
    @user = stub_model(User, :id => 1, :role => "")
    @editor = stub_model(User, :id => 2, :role => "editor")
    @admin = stub_model(User, :id => 3, :role => "admin")
  end

  describe "responding to GET index" do

    describe "not editor" do
      it "should expose all news as @news" do
        delegate = mock()
        delegate.should_receive(:translated).and_return([mock_news])
        News.should_receive(:published).and_return(delegate)
        get :index
        assigns[:news].should == [mock_news]
      end

      describe "with mime type of xml" do
        it "should render all news as xml" do
          request.env["HTTP_ACCEPT"] = "application/xml"
          delegate = mock()
          news = mock("Array of News")
          delegate.should_receive(:translated).with().and_return(news)
          News.should_receive(:published).and_return(delegate)
          news.should_receive(:to_xml).and_return("generated XML")
          get :index
          response.body.should == "generated XML"
        end
      end
    end

    describe "editor" do
      it "should expose all news as @news" do
        login_as @editor
        News.should_receive(:translated).with().and_return([mock_news])
        get :index
        assigns[:news].should == [mock_news]
      end

      describe "with mime type of xml" do
        it "should render all news as xml" do
          login_as @editor
          request.env["HTTP_ACCEPT"] = "application/xml"
          news = mock("Array of News")
          News.should_receive(:translated).with().and_return(news)
          news.should_receive(:to_xml).and_return("generated XML")
          get :index
          response.body.should == "generated XML"
        end
      end
    end
  end

  describe "responding to GET show" do

    it "should expose the requested news as @news" do
      News.should_receive(:find).with("37").and_return(mock_news)
      mock_news.should_receive(:translation).and_return(mock_news)
      get :show, :id => "37"
      assigns[:news].should equal(mock_news)
    end

    describe "with mime type of xml" do

      it "should render the requested news as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        News.should_receive(:find).with("37").and_return(mock_news)
        mock_news.should_receive(:translation).and_return(mock_news)
        mock_news.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET new" do
    it "shouldn't be accessible for non-logined user" do
      get :new
      response.should redirect_to(new_session_path)
    end

    it "shouldn't be accessible for normal user" do
      login_as @user
      get :new
      assert_response 403
    end

    describe "should expose a new news as @news" do
      it "populating news by parameter" do
        login_as @editor
        @mock = mock_news
        parent = stub_model(News, :title => "Title", :lead => "Lead", :body => "Body")
        News.should_receive(:new).and_return(@mock)
        mock_news.should_receive(:locale=).with('be')
        mock_news.should_receive(:parent_id=).with("5")
        mock_news.should_receive(:title=).with("Title")
        mock_news.should_receive(:lead=).with("Lead")
        mock_news.should_receive(:body=).with("Body")
        News.should_receive(:find).with('5').and_return(parent)

        get :new, :locale => 'be', :parent_id => '5'
        assert_response :success
        assigns[:news].should equal(mock_news)
      end

      it "using default locale by default" do
        login_as @editor
        @mock = mock_news
        News.should_receive(:new).and_return(@mock)
        I18n.stub!(:default_locale).and_return('zz')
        mock_news.should_receive(:locale=).with('zz')
        get :new
        assert_response :success
        assigns[:news].should equal(mock_news)
      end
    end

  end

  describe "responding to GET edit" do
    it "shouldn't be accessible for non-logined user" do
      get :edit, :id => "123"
      response.should redirect_to(new_session_path)
    end

    it "shouldn't be accessible for normal user" do
      login_as @user
      get :edit, :id => "123"
      assert_response 403
    end

    it "should expose the requested news as @news" do
      login_as @editor
      News.should_receive(:find).with("37").and_return(mock_news)
      get :edit, :id => "37"
      assigns[:news].should equal(mock_news)
    end

  end

  describe "responding to POST create" do
    it "shouldn't be accessible for non-logined user" do
      post :create
      response.should redirect_to(new_session_path)
    end

    it "shouldn't be accessible for normal user" do
      login_as @user
      post :create
      assert_response 403
    end

    describe "with valid params" do

      it "should expose a newly created news as @news" do
        login_as @editor
        n = mock_news(:save => true)
        News.should_receive(:new).with({'these' => 'params'}).and_return(n)
        n.should_receive(:user=).with(@editor)
        post :create, :news => {:these => 'params'}
        assigns(:news).should equal(mock_news)
      end

      it "should redirect to the created news" do
        login_as @editor
        n = mock_news(:save => true)
        News.stub!(:new).and_return(n)
        n.should_receive(:user=).with(@editor)
        post :create, :news => {}
        response.should redirect_to(news_item_url(:id=>n))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved news as @news" do
        login_as @editor
        n = mock_news(:save => true)
        News.stub!(:new).with({'these' => 'params'}).and_return(n)
        n.should_receive(:user=).with(@editor)
        post :create, :news => {:these => 'params'}
        assigns(:news).should equal(mock_news)
      end

      it "should re-render the 'new' template" do
        login_as @editor
        n = mock_news(:save => false)
        News.stub!(:new).and_return(n)
        n.should_receive(:user=).with(@editor)
        post :create, :news => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT update" do
    it "shouldn't be accessible for non-logined user" do
      post :update, :id => "123"
      response.should redirect_to(new_session_path)
    end

    it "shouldn't be accessible for normal user" do
      login_as @user
      post :update, :id => "123"
      assert_response 403
    end

    describe "with valid params" do

      it "should update the requested news" do
        login_as @editor
        News.should_receive(:find).with("37").and_return(mock_news)
        mock_news.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :news => {:these => 'params'}
      end

      it "should expose the requested news as @news" do
        login_as @editor
        News.stub!(:find).and_return(mock_news(:update_attributes => true))
        put :update, :id => "1"
        assigns(:news).should equal(mock_news)
      end

      it "should redirect to the news" do
        login_as @editor
        mock = mock_news(:update_attributes => true)
        News.stub!(:find).and_return(mock)
        put :update, :id => "1"
        response.should redirect_to(news_item_url(:id=>mock))
      end

    end

    describe "with invalid params" do

      it "should update the requested news" do
        login_as @editor
        News.should_receive(:find).with("37").and_return(mock_news)
        mock_news.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :news => {:these => 'params'}
      end

      it "should expose the news as @news" do
        login_as @editor
        News.stub!(:find).and_return(mock_news(:update_attributes => false))
        put :update, :id => "1"
        assigns(:news).should equal(mock_news)
      end

      it "should re-render the 'edit' template" do
        login_as @editor
        News.stub!(:find).and_return(mock_news(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do
    it "shouldn't be accessible for non-logined user" do
      delete :destroy, :id => "123"
      response.should redirect_to(new_session_path)
    end

    it "shouldn't be accessible for normal user" do
      login_as @user
      delete :destroy, :id => "123"
      assert_response 403
    end


    it "should destroy the requested news" do
      login_as @editor
      News.should_receive(:find).with("37").and_return(mock_news)
      mock_news.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the news list" do
      login_as @editor
      News.stub!(:find).and_return(mock_news(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(news_item_url)
    end
  end

  describe "responding to publish" do
    it "shouldn't be accessible for non-logined user" do
      get :publish, :id => "123"
      response.should redirect_to(new_session_path)
    end

    it "shouldn't be accessible for normal user" do
      login_as @user
      get :publish, :id => "123"
      assert_response 403
    end


    it "should publish the requested news" do
      login_as @editor
      News.should_receive(:find).with("37").and_return(mock_news)
      mock_news.should_receive(:publish)
      get :publish, :id => "37"
    end

    it "should publish parent news if exists" do
      login_as @editor
      mock_news(:parent_id => 42);
      News.should_receive(:find).with("37").and_return(mock_news)
      parent_news = mock
      parent_news.stub!(:id).and_return(1)
      News.should_receive(:find).with(42).and_return(parent_news)
      parent_news.should_receive(:publish)
      get :publish, :id => "37"
    end

    it "should redirect to the news list" do
      login_as @editor
      News.stub!(:find).and_return(mock_news(:publish => true))
      delete :publish, :id => "1"
      response.should redirect_to(news_item_url(:id => mock_news.id))
    end
  end

  describe "responding to publish_now" do
    it "shouldn't be accessible for non-logined user" do
      get :publish_now, :id => 123
      response.should redirect_to(new_session_path)
    end

    it "shouldn't be accessible for normal user" do
      login_as @user
      get :publish_now, :id => 123
      assert_response 403
    end

    it "shouldn't be accessible for normal user" do
      login_as @editor
      get :publish_now, :id => 123
      assert_response 403
    end

    it "should publish the requested news" do
      login_as @admin
      News.should_receive(:find).with("37").and_return(mock_news)
      mock_news.should_receive(:publish_now)
      get :publish_now, :id => "37"
    end

    it "should publish parent news if exists" do
      login_as @admin
      mock_news(:parent_id => 42);
      News.should_receive(:find).with("37").and_return(mock_news)
      parent_news = mock
      parent_news.stub!(:id).and_return(1)
      News.should_receive(:find).with(42).and_return(parent_news)
      parent_news.should_receive(:publish_now)
      get :publish_now, :id => "37"
    end

    it "should redirect to the news list" do
      login_as @admin
      News.stub!(:find).and_return(mock_news(:publish_now => true))
      get :publish_now, :id => "1"
      response.should redirect_to(news_item_url(:id => mock_news.id))
    end
  end

  describe "responding to GET rss" do
    it "should expose all news as @news" do
      delegate = mock()
      delegate.should_receive(:translated).and_return([mock_news])
      News.should_receive(:published).and_return(delegate)
      get :rss
      assigns[:news].should == [mock_news]
    end
  end

end
