require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::UsersController do
  def mock_user(stubs={})
    model_stub(User, stubs)
  end

  before :all do
    @user = mock_user(:id => 100, :admin? => false, :editor? => false)
    @admin = mock_user(:id => 1, :admin? => true, :editor? => true)
  end

  describe 'index' do
    integrate_views
    it "should be accessible by right URL" do
      params_from(:get, '/ru/admin/users').should == {
        :controller => 'admin/users',
        :action => 'index',
        :lang => 'ru'
      }
      params_from(:get, '/ru/admin/users.csv').should == {
        :controller => 'admin/users',
        :action => 'index',
        :format => 'csv',
        :lang => 'ru'
      }
    end

    it "should be accessible only for admin" do
      login_as(@admin)
      get :index

      assert_response :success

      login_as(@user)
      get :index

      assert_response 403
    end

    it "should render html if requested" do
      login_as @admin
      User.stubs(:find).with(:all, :include => :conference_registrations).returns([])
      get :index, :format=>'html'
      assert_response :success
    end

    it "should render all if required" do
      login_as(@admin)
      @conference = Conference.create!(:name => "LVEE 2009")
      @user = User.create!(User.valid_data)
      @reg = ConferenceRegistration.create!(:conference => @conference, :user => @user,
        :status_name => "approved",
        :transport_from => "bus_minsk",
        :transport_to => "bus_minsk"
        )

      get :index, :format=>'html'
      assert_response :success
    end
  end

  describe "set_role" do
    it "should be accessible by right URL" do
      params_from(:post, '/ru/admin/users/set_role/42').should == {
        :controller => 'admin/users',
        :action => 'set_role',
        :id=>'42',
        :lang => 'ru'
      }
    end
    it "should forbid set role if user is not admin" do
      login_as(@user)

      get :set_role, :id=> 12, :role => 'admin'
      assert_response 403
    end

    it "should allow admin set role for user" do
      login_as(@admin)

      user = mock()
      user.expects(:role=).with('admin')
      user.expects(:save!)
      User.expects(:find).with('12').returns(user)

      get :set_role, :id=> 12, :role => 'admin'
      assert_response :success
    end
  end

  describe "destroy" do
    it "should be accessible by right URL" do
      params_from(:delete, '/ru/admin/users/42').should == {
        :controller => 'admin/users',
        :action => 'destroy',
        :id=>'42',
        :lang=> 'ru'
      }
    end
    it "should forbid delete user if user is not admin" do
      login_as(@user)

      get :destroy, :id=> 12
      assert_response 403
    end

    it "should allow admin delete any user" do
      login_as(@admin)

      user = mock()
      user.expects(:destroy).returns(true)
      user.expects(:id).returns(12)
      User.expects(:find).with('12').returns(user)

      get :destroy, :id=> 12
      assert_response :success
    end
  end

end
