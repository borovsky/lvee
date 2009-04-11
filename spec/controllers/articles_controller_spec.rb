require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArticlesController do

  def mock_article(stubs={})
    @mock_article ||= model_stub(Article, stubs)
  end

  before :each do
    @editor=stub(:id => 2, :editor? => true, :admin? => false)
    login_as @editor
  end

  describe "responding to GET index" do

    it "should expose all articles as @articles" do
      Article.expects(:translated).with().returns([mock_article])
      get :index
      assigns[:articles].should == [mock_article]
    end

    describe "with mime type of xml" do

      it "should render all articles as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Article.expects(:translated).with().returns(articles = mock("Array of Articles"))
        articles.expects(:to_xml).returns("generated XML")
        get :index
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET show" do

    it "should expose the requested article as @article" do
      Article.expects(:find_by_id).with("37").returns(mock_article)
      get :show, :id => "37"
      assigns[:article].should equal(mock_article)
    end

    describe "with mime type of xml" do

      it "should render the requested article as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Article.expects(:find_by_id).with("37").returns(mock_article)
        mock_article.expects(:to_xml).returns("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET new" do

    it "should expose a new article as @article" do
      Article.expects(:new).returns(mock_article)
      get :new
      assigns[:article].should equal(mock_article)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested article as @article" do
      Article.expects(:find_by_id).with("37").returns(mock_article)
      get :edit, :id => "37"
      assigns[:article].should equal(mock_article)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created article as @article" do
        Article.expects(:new).with({'these' => 'params'}).returns(mock_article(:save => true))
        post :create, :article => {:these => 'params'}
        assigns(:article).should equal(mock_article)
      end

      it "should redirect to the created article" do
        Article.stubs(:new).returns(mock_article(:save => true))
        post :create, :article => {}
        response.should redirect_to(article_url(:id => mock_article.id))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved article as @article" do
        Article.stubs(:new).with({'these' => 'params'}).returns(mock_article(:save => false))
        post :create, :article => {:these => 'params'}
        assigns(:article).should equal(mock_article)
      end

      it "should re-render the 'new' template" do
        Article.stubs(:new).returns(mock_article(:save => false))
        post :create, :article => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT update" do

    describe "with valid params" do

      it "should update the requested article" do
        Article.expects(:find_by_id).with("37").returns(mock_article)
        mock_article.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :article => {:these => 'params'}
      end

      it "should expose the requested article as @article" do
        Article.stubs(:find_by_id).returns(mock_article(:update_attributes => true))
        put :update, :id => "1"
        assigns(:article).should equal(mock_article)
      end

      it "should redirect to the article" do
        Article.stubs(:find_by_id).returns(mock_article(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(article_url(:id => mock_article.id))
      end

    end

    describe "with invalid params" do

      it "should update the requested article" do
        Article.expects(:find_by_id).with("37").returns(mock_article)
        mock_article.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :article => {:these => 'params'}
      end

      it "should expose the article as @article" do
        Article.stubs(:find_by_id).returns(mock_article(:update_attributes => false))
        put :update, :id => "1"
        assigns(:article).should equal(mock_article)
      end

      it "should re-render the 'edit' template" do
        Article.stubs(:find_by_id).returns(mock_article(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested article" do
      Article.expects(:find_by_id).with("37").returns(mock_article)
      mock_article.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the articles list" do
      Article.stubs(:find).returns(mock_article(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(articles_url)
    end

  end

end
