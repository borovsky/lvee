require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConferenceRegistrationsController do
  def mock_registration(stubs={})
    model_stub(ConferenceRegistration, stubs)
  end

  def mock_conference(stubs={})
    model_stub(Conference, stubs)
  end

  def mock_user(stubs={})
    model_stub(User, stubs)
  end

  before :all do
    @user=mock_user(:id => 1)
    @other_user=mock_user(:id => 2)
  end

  describe "GET 'index'" do
    it "should show registrations for current user" do
      login_as @user
      get 'index', :user_id => '1'
      response.should be_success
    end

    it "shouldn't show registrations for other users" do
      login_as @user
      get 'index', :user_яid => '2'
      assert_response 403
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      login_as @user
      conference = mock_conference(:id => '123', :registration_opened => true)
      Conference.stubs(:find).with('123').returns(conference)
      reg = mock_registration()
      ConferenceRegistration.stubs(:new).with(:conference => conference).returns(reg)
      get 'new', :user_id => '1', :conference_id => '123'
      response.should be_success
      assigns(:registration).should == reg
    end
  end

  describe "POST 'create'" do
    it "should redirect to show registration, if validation successful" do
      login_as @user
      params = {:user_id => '1', :conference_id => '1'}
      reg = mock_registration(params)
      ConferenceRegistration.stubs(:new).with(params.stringify_keys).returns(reg)
      reg.stubs(:status_name=).with('New')
      reg.stubs(:user_id=).with(1)
      reg.stubs(:save).returns(true)
      conference = mock_conference(:id => '1', :registration_opened => true)
      Conference.stubs(:find).with('1').returns(conference)

      post 'create', :user_id => 1, :conference_registration => params
      assert_redirected_to user_conference_registration_path(reg.user_id, reg.id)
    end

    it "should render 'new', if validation failed" do
      login_as @user
      params = {:user_id => '1', :conference_id => '1'}
      reg = mock_registration(params)
      ConferenceRegistration.stubs(:new).with(params.stringify_keys).returns(reg)
      reg.stubs(:status_name=).with('New')
      reg.stubs(:user_id=).with(1)
      reg.stubs(:save).returns(false)
      conference = mock_conference(:id => '1', :registration_opened => true)
      Conference.stubs(:find).with('1').returns(conference)

      post 'create', :user_id => 1, :conference_registration => params
      response.should be_success
      response.should render_template('conference_registrations/new')
      assigns(:registration).should == reg
    end
  end

  describe "GET 'edit'" do
    it "should be successful if requested right registration" do
      login_as @user
      reg = mock_registration(:id => 42)
      ConferenceRegistration.stubs(:find_by_id_and_user_id).with('42', '1').returns(reg)
      get 'edit', :user_id => '1', :id => '42'
      response.should be_success
      assigns(:registration).should == reg
    end

    it "should redirect to index if specified registration fot other user" do
      login_as @user
      ConferenceRegistration.stubs(:find_by_id_and_user_id).with('42', '1').returns(nil)
      get 'edit', :user_id => '1', :id => '42'
      assert_response 403
    end
  end

  describe "POST 'update'" do
    it "should redirect to  if registration is valid" do
      login_as @user
      reg = mock_registration(:id => 42)
      ConferenceRegistration.stubs(:find_by_id_and_user_id).with('42', '1').returns(reg)
      reg.expects(:update_attributes).with('proposition' => 'test').returns(true)
      post 'update', :user_id => '1', :id => 42, :conference_registration => {:proposition => 'test'}
      response.should redirect_to(user_conference_registration_path(@user.id, 1))
    end

    it "should render edit if registration isn't valid" do
      login_as @user
      reg = mock_registration(:id => 42)
      ConferenceRegistration.stubs(:find_by_id_and_user_id).with('42', '1').returns(reg)
      reg.expects(:update_attributes).with('proposition' => 'test').returns(false)
      post 'update', :user_id => '1', :id => 42, :conference_registration => {:proposition => 'test'}
      assert_response :success
      assigns(:registration).should == reg
      response.should render_template('conference_registrations/edit')
    end
  end

  describe "GET 'show'" do
    it "should show registration to current user" do
      login_as @user
      reg = mock_registration(:id => 42)
      ConferenceRegistration.stubs(:find_by_id_and_user_id).with('42', '1').returns(reg)
      get 'show', :user_id => '1', :id => 42
      response.should be_success
      response.should render_template('conference_registrations/show')
      assigns(:registration).should == reg
    end

    it "shouldn't show registration for other users" do
      login_as @user
      ConferenceRegistration.stubs(:find_by_id_and_user_id).with('42', '1').returns(nil)
      get 'show', :user_id => '1', :id => 42
      assert_response 403
    end
  end
end
