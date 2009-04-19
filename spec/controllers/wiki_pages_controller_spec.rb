require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WikiPagesController do

  def mock_wiki_page(stubs={})
    @mock_wiki_page ||= model_stub(WikiPage, stubs)
  end

  before :each do
    @editor=stub(:id => 2, :editor? => true, :admin? => false)
    login_as @editor
  end

  describe "responding to GET index" do

    it "should expose all wiki_pages as @wiki_pages" do
      WikiPage.expects(:all).with().returns([mock_wiki_page])
      get :index
      assigns[:wiki_pages].should == [mock_wiki_page]
    end

    describe "with mime type of xml" do

      it "should render all wiki_pages as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        WikiPage.expects(:all).with().returns(wiki_pages = mock("Array of WikiPages"))
        wiki_pages.expects(:to_xml).returns("generated XML")
        get :index
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET show" do

    it "should expose the requested wiki_page as @wiki_page" do
      WikiPage.expects(:find_by_name).with("test_name").returns(mock_wiki_page)
      get :show, :id => "test_name"
      assigns[:wiki_page].should equal(mock_wiki_page)
    end

    describe "with mime type of xml" do

      it "should render the requested wiki_page as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        WikiPage.expects(:find_by_name).with("37").returns(mock_wiki_page)
        mock_wiki_page.expects(:to_xml).returns("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET new" do

    it "should expose a new wiki_page as @wiki_page" do
      WikiPage.expects(:new).returns(mock_wiki_page)
      get :new
      assigns[:wiki_page].should equal(mock_wiki_page)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested wiki_page as @wiki_page" do
      WikiPage.expects(:find_by_name).with("37").returns(mock_wiki_page)
      get :edit, :id => "37"
      assigns[:wiki_page].should equal(mock_wiki_page)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created wiki_page as @wiki_page" do
        WikiPage.expects(:new).with({'these' => 'params'}).returns(mock_wiki_page(:save => true, :user_id= => nil, :name => "name"))
        post :create, :wiki_page => {:these => 'params'}
        assigns(:wiki_page).should equal(mock_wiki_page)
      end

      it "should set user_id" do
        WikiPage.expects(:new).with({'these' => 'params'}).returns(mock_wiki_page(:save => true, :name => "name"))
        mock_wiki_page.expects(:user_id=).with(2)
        post :create, :wiki_page => {:these => 'params'}
        assigns(:wiki_page).should equal(mock_wiki_page)
      end

      it "should redirect to the created wiki_page" do
        WikiPage.stubs(:new).returns(mock_wiki_page(:save => true, :user_id= => nil, :name => "name"))
        post :create, :wiki_page => {}
        response.should redirect_to(wiki_page_url(:id => mock_wiki_page.name))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved wiki_page as @wiki_page" do
        WikiPage.stubs(:new).with({'these' => 'params'}).returns(mock_wiki_page(:save => false, :user_id= => nil))
        post :create, :wiki_page => {:these => 'params'}
        assigns(:wiki_page).should equal(mock_wiki_page)
      end

      it "should re-render the 'new' template" do
        WikiPage.stubs(:new).returns(mock_wiki_page(:save => false, :user_id= => nil))
        post :create, :wiki_page => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT update" do

    describe "with valid params" do

      it "should update the requested wiki_page" do
        WikiPage.expects(:find_by_name).with("37").returns(mock_wiki_page(:user_id= => nil))
        mock_wiki_page.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :wiki_page => {:these => 'params'}
      end

      it "should expose the requested wiki_page as @wiki_page" do
        WikiPage.stubs(:find_by_name).returns(mock_wiki_page(:update_attributes => true, :user_id= => nil))
        put :update, :id => "1"
        assigns(:wiki_page).should equal(mock_wiki_page)
      end

      it "should set current user_id to wiki_page" do
        WikiPage.stubs(:find_by_name).returns(mock_wiki_page(:update_attributes => true))
        mock_wiki_page.expects(:user_id=).with(2)
        put :update, :id => "1"
        assigns(:wiki_page).should equal(mock_wiki_page)
      end

      it "should redirect to the wiki_page" do
        WikiPage.stubs(:find_by_name).returns(mock_wiki_page(:update_attributes => true, :user_id= => nil, :name => "test_name"))
        put :update, :id => "test_name"
        response.should redirect_to(wiki_page_url(:id => mock_wiki_page.name))
      end

    end

    describe "with invalid params" do

      it "should update the requested wiki_page" do
        WikiPage.expects(:find_by_name).with("37").returns(mock_wiki_page(:user_id= => nil))
        mock_wiki_page.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :wiki_page => {:these => 'params'}
      end

      it "should expose the wiki_page as @wiki_page" do
        WikiPage.stubs(:find_by_name).returns(mock_wiki_page(:update_attributes => false, :user_id= => nil))
        put :update, :id => "1"
        assigns(:wiki_page).should equal(mock_wiki_page)
      end

      it "should re-render the 'edit' template" do
        WikiPage.stubs(:find_by_name).returns(mock_wiki_page(:update_attributes => false, :user_id= => nil))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end
end
