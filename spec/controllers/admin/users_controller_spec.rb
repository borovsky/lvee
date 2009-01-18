#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::UsersController do
  before :all do
    @user = stub(:user)
    @user.stubs(:id).returns(100)
    @admin = stub(:admin)
    @admin.stubs(:id).returns(1)
  end

  describe 'index' do
    it "should be accessible by right URL" do
      params_from(:get, '/admin/users').should == {
        :controller => 'admin/users',
        :action => 'index',
      }
      params_from(:get, '/admin/users.csv').should == {
        :controller => 'admin/users',
        :action => 'index',
        :format => 'csv',
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
      User.stubs(:find).with(:all).returns([])
      get :index, :format=>'html'
      assert_response :success
    end

    it "should render csv if requested" do
      login_as @admin
      User.stubs(:find).with(:all).returns([])
      get :index, :format=>'csv'
      assert_response :success
    end
  end

  describe "destroy" do
    it "should be accessible by right URL" do
      params_from(:delete, '/admin/users/42').should == {
        :controller => 'admin/users',
        :action => 'destroy',
        :id=>'42',
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
