require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::ConferencesController do

  def mock_conference(stubs={})
    @mock_conference ||= model_stub(Conference, stubs)
  end

  def mock_user(stubs={})
    model_stub(User, stubs)
  end

  before(:all) do
    @user = mock_user(:id => 100, :admin? => false)
    @admin = mock_user(:id => 1, :admin? => true)
  end

  describe "responding to GET index" do
    it "shouldn't be accessible for non-logined user" do
      get :index
      response.should redirect_to(new_session_path)
    end

    it "shouldn't be accessible for normal user" do
      login_as @user
      get :index
      assert_response 403
    end

    it "should expose all conferences as @conferences" do
      login_as @admin
      Conference.expects(:find).with(:all).returns([mock_conference])
      get :index
      assigns[:conferences].should == [mock_conference]
    end

    describe "with mime type of xml" do

      it "should render all conferences as xml" do
        login_as @admin
        request.env["HTTP_ACCEPT"] = "application/xml"
        Conference.expects(:find).with(:all).returns(conferences = mock("Array of Conferences"))
        conferences.expects(:to_xml).returns("generated XML")
        get :index
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET show" do
    it "shouldn't be accessible for non-logined user" do
      get :show
      response.should redirect_to(new_session_path)
    end

    it "shouldn't be accessible for normal user" do
      login_as @user
      get :show
      assert_response 403
    end

    it "should expose the requested conference as @conference" do
      login_as @admin
      Conference.expects(:find).with("37").returns(mock_conference)
      get :show, :id => "37"
      assigns[:conference].should equal(mock_conference)
    end

    describe "with mime type of xml" do

      it "should render the requested conference as xml" do
        login_as @admin
        request.env["HTTP_ACCEPT"] = "application/xml"
        Conference.expects(:find).with("37").returns(mock_conference)
        mock_conference.expects(:to_xml).returns("generated XML")
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

    it "should expose a new conference as @conference" do
      login_as @admin
      Conference.expects(:new).returns(mock_conference)
      get :new
      assigns[:conference].should equal(mock_conference)
    end

  end

  describe "responding to GET edit" do
    it "shouldn't be accessible for non-logined user" do
      get :edit
      response.should redirect_to(new_session_path)
    end

    it "shouldn't be accessible for normal user" do
      login_as @user
      get :edit
      assert_response 403
    end

    it "should expose the requested conference as @conference" do
      login_as @admin
      Conference.expects(:find).with("37").returns(mock_conference)
      get :edit, :id => "37"
      assigns[:conference].should equal(mock_conference)
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

      it "should expose a newly created conference as @conference" do
        login_as @admin
        Conference.expects(:new).with({'these' => 'params'}).returns(mock_conference(:save => true))
        post :create, :conference => {:these => 'params'}
        assigns(:conference).should equal(mock_conference)
      end

      it "should redirect to the created conference" do
        login_as @admin
        Conference.stubs(:new).returns(mock_conference(:save => true))
        post :create, :conference => {}
        response.should redirect_to(admin_conference_url(:id => mock_conference.id))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved conference as @conference" do
        login_as @admin
        Conference.stubs(:new).with({'these' => 'params'}).returns(mock_conference(:save => false))
        post :create, :conference => {:these => 'params'}
        assigns(:conference).should equal(mock_conference)
      end

      it "should re-render the 'new' template" do
        login_as @admin
        Conference.stubs(:new).returns(mock_conference(:save => false))
        post :create, :conference => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do
    it "shouldn't be accessible for non-logined user" do
      put :update
      response.should redirect_to(new_session_path)
    end

    it "shouldn't be accessible for normal user" do
      login_as @user
      put :update
      assert_response 403
    end

    describe "with valid params" do

      it "should update the requested conference" do
        login_as @admin
        Conference.expects(:find).with("37").returns(mock_conference)
        mock_conference.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :conference => {:these => 'params'}
      end

      it "should expose the requested conference as @conference" do
        login_as @admin
        Conference.stubs(:find).returns(mock_conference(:update_attributes => true))
        put :update, :id => "1"
        assigns(:conference).should equal(mock_conference)
      end

      it "should redirect to the conference" do
        login_as @admin
        Conference.stubs(:find).returns(mock_conference(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(admin_conference_url(:id=>mock_conference))
      end

    end

    describe "with invalid params" do

      it "should update the requested conference" do
        login_as @admin
        Conference.expects(:find).with("37").returns(mock_conference)
        mock_conference.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :conference => {:these => 'params'}
      end

      it "should expose the conference as @conference" do
        login_as @admin
        Conference.stubs(:find).returns(mock_conference(:update_attributes => false))
        put :update, :id => "1"
        assigns(:conference).should equal(mock_conference)
      end

      it "should re-render the 'edit' template" do
        login_as @admin
        Conference.stubs(:find).returns(mock_conference(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do
    it "shouldn't be accessible for non-logined user" do
      put :update
      response.should redirect_to(new_session_path)
    end

    it "shouldn't be accessible for normal user" do
      login_as @user
      put :update
      assert_response 403
    end

    it "should destroy the requested conference" do
      login_as @admin
      Conference.expects(:find).with("37").returns(mock_conference)
      mock_conference.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the conferences list" do
      login_as @admin
      Conference.stubs(:find).returns(mock_conference(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(admin_conferences_url)
    end

  end

end
