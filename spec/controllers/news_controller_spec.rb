require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsController do

  def mock_news(stubs={})
    @mock_news ||= model_stub(News, stubs)
  end

  before :all do
    @user=stub(:id => 1)
  end

  describe "responding to GET index" do

    it "should expose all news as @news" do
      News.expects(:find).with(:all).returns([mock_news])
      get :index
      assigns[:news].should == [mock_news]
    end

    describe "with mime type of xml" do

      it "should render all news as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        News.expects(:find).with(:all).returns(news = mock("Array of News"))
        news.expects(:to_xml).returns("generated XML")
        get :index
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET show" do

    it "should expose the requested news as @news" do
      News.expects(:find).with("37").returns(mock_news)
      get :show, :id => "37"
      assigns[:news].should equal(mock_news)
    end

    describe "with mime type of xml" do

      it "should render the requested news as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        News.expects(:find).with("37").returns(mock_news)
        mock_news.expects(:to_xml).returns("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET new" do

    it "should expose a new news as @news" do
      News.expects(:new).returns(mock_news)
      get :new
      assigns[:news].should equal(mock_news)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested news as @news" do
      News.expects(:find).with("37").returns(mock_news)
      get :edit, :id => "37"
      assigns[:news].should equal(mock_news)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created news as @news" do
        login_as @user
        n = mock_news(:save => true)
        News.expects(:new).with({'these' => 'params'}).returns(n)
        n.expects(:user=).with(@user)
        post :create, :news => {:these => 'params'}
        assigns(:news).should equal(mock_news)
      end

      it "should redirect to the created news" do
        login_as @user
        n = mock_news(:save => true)
        News.stubs(:new).returns(n)
        n.expects(:user=).with(@user)
        post :create, :news => {}
        response.should redirect_to(news_item_url(n))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved news as @news" do
        login_as @user
        n = mock_news(:save => true)
        News.stubs(:new).with({'these' => 'params'}).returns(n)
        n.expects(:user=).with(@user)
        post :create, :news => {:these => 'params'}
        assigns(:news).should equal(mock_news)
      end

      it "should re-render the 'new' template" do
        login_as @user
        n = mock_news(:save => false)
        News.stubs(:new).returns(n)
        n.expects(:user=).with(@user)
        post :create, :news => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT update" do

    describe "with valid params" do

      it "should update the requested news" do
        News.expects(:find).with("37").returns(mock_news)
        mock_news.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :news => {:these => 'params'}
      end

      it "should expose the requested news as @news" do
        News.stubs(:find).returns(mock_news(:update_attributes => true))
        put :update, :id => "1"
        assigns(:news).should equal(mock_news)
      end

      it "should redirect to the news" do
        mock = mock_news(:update_attributes => true)
        News.stubs(:find).returns(mock)
        put :update, :id => "1"
        response.should redirect_to(news_item_url(mock))
      end

    end

    describe "with invalid params" do

      it "should update the requested news" do
        News.expects(:find).with("37").returns(mock_news)
        mock_news.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :news => {:these => 'params'}
      end

      it "should expose the news as @news" do
        News.stubs(:find).returns(mock_news(:update_attributes => false))
        put :update, :id => "1"
        assigns(:news).should equal(mock_news)
      end

      it "should re-render the 'edit' template" do
        News.stubs(:find).returns(mock_news(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested news" do
      News.expects(:find).with("37").returns(mock_news)
      mock_news.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the news list" do
      News.stubs(:find).returns(mock_news(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(news_url)
    end

  end

end
