require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::UsersController do
  def mock_user(stubs={})
    stub_model(User, stubs)
  end

  before do
    @user = mock_user(:id => 100, :role => "")
    @admin = mock_user(:id => 1, :role => "admin")
    @editor = mock_user(:id => 2, :role => "editor")
  end

  describe 'index' do
    render_views

    it "should be accessible for admin" do
      login_as(@admin)
      get :index

      assert_response :success
    end

    it "shouldn't be accessible for user" do
      login_as(@user)
      get :index

      assert_response 403
    end

    it "shouldn't be accessible for editor" do
      login_as(@editor)
      get :index

      assert_response 403
    end

    it "should render html if requested" do
      login_as @admin

      get :index, :format=>'html'
      assert_response :success
    end

    it "should render all if required" do
      login_as(@admin)
      Status.create(:name => "approved", :subject => "", :mail => "")
      @conference = Conference.create!(:name => "LVEE 2009")
      @user = User.create!(User.valid_data)
      @reg = ConferenceRegistration.create!({:conference_id => @conference.id, :user_id => @user.id,
                                              :status_name => "approved",
                                              :transport_from => "bus_minsk",
                                              :transport_to => "bus_minsk",
                                              :quantity => 1
                                            }, without_protection: true)

      get :index, :format=>'html'
      assert_response :success
    end
  end

  describe "set_role" do
    it "should forbid set role if user is not admin" do
      login_as(@user)

      get :set_role, :id=> 12, :role => 'admin'
      assert_response 403
    end

    it "should allow admin set role for user" do
      login_as(@admin)

      user = mock()
      user.should_receive(:role=).with('admin')
      user.should_receive(:save!)
      User.should_receive(:find).with('12').and_return(user)

      get :set_role, :id=> '12', :role => 'admin'
      assert_response :success
    end
  end

  describe "destroy" do
    it "should forbid delete user if user is not admin" do
      login_as(@user)

      get :destroy, :id=> 12
      assert_response 403
    end

    it "should allow admin delete any user" do
      login_as(@admin)

      user = mock()
      user.should_receive(:destroy).and_return(true)
      User.should_receive(:find).with('12').and_return(user)

      get :destroy, :id=> '12'
      assert_response :success
    end
  end

end
