#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  def mock_user(stubs={})
    stub_model(User, stubs)
  end

  before :all do
    @user = mock_user(:id => 100, :admin? => false)
    @admin = mock_user(:id => 1, :admin? => true)
  end

  describe 'activate' do
    it "should be accessible by right URL" do
      params_from(:get, '/activate/42').should == {
        :controller => 'users',
        :action => 'activate',
        :activation_code => '42'
      }
    end
    it 'should activate user for specified code' do
      user = mock()
      User.expects(:find_by_activation_code).with('42').returns(user)
      user.expects(:active?).returns(false)
      user.expects(:activate)
      user.expects(:id).returns(69)
      user.expects(:to_s).returns('69')
      get :activate, :activation_code => '42'
      assert_redirected_to '/en/users/69'
    end

    it 'should redirect to root if user with activation_code not found' do
      User.expects(:find_by_activation_code).with('42').returns(nil)
      get :activate, :activation_code => '42'
      assert_redirected_to '/'
    end

    it 'should redirect to root if user already active' do
      user = mock()
      User.expects(:find_by_activation_code).with('42').returns(user)
      user.expects(:active?).returns(true)
      get :activate, :activation_code => '42'
      assert_redirected_to '/'
    end
  end

  describe 'show' do
    it "should be accessible by right URL" do
      params_from(:get, '/ru/users/42').should == {
        :controller => 'users',
        :action => 'show',
        :id=>'42',
        :lang => 'ru'
      }
    end

    it 'accessible only for logged in user' do
      @controller.stubs(:logged_in?).returns(false)
      get :show, :id=> '42'
      assert_redirected_to new_session_path
    end

    it 'can show current user' do
      logged_in_user = stub("logged_in_user", :admin? => false)
      logged_in_user.stubs(:id).returns(42)
      login_as(logged_in_user)

      user = stub("user")
      User.stubs(:find).with('42').returns(user)

      get :show, :id=> '42'
      assert_response :success
      assigns(:user).should == user
    end

    it "can't show other users" do
      logged_in_user = mock_user(:id => 1234, :admin? => false)
      login_as(logged_in_user)

      user = mock_user()
      User.stubs(:find).with('42').returns(user)

      get :show, :id=> '42'
      assert_response 403
    end


    it 'admin can view any user' do
      login_as(@admin)

      user = stub(:user)
      User.stubs(:find).with('42').returns(user)

      get :show, :id=> '42'
      assert_response :success
      assigns(:user).should == user
    end
  end

  describe "edit" do
    it "should be accessible for current user" do
      login_as @user
      @user.stubs(:full_name).returns("Test")

      User.stubs(:find).with('100').returns(@user)
      controller.stubs(:edit).returns(true)

      get :edit, :id => '100'
      assert_response :success
    end

    it "should not be  accessible for other user" do
      login_as @user
      @user.stubs(:full_name).returns("Test")

      User.stubs(:find).with('42').returns(@user)
      controller.stubs(:edit).returns(true)

      get :edit, :id => '42'
      assert_response 403
    end
  end

  describe "current" do
    it "should be accessible by right URL" do
      params_from(:get, '/be/users/current').should == {
        :controller => 'users',
        :action => 'current',
        :lang => 'be'
      }
    end

    it 'accessible only for logged in user' do
      @controller.stubs(:logged_in?).returns(false)
      get :current
      assert_redirected_to new_session_path
    end

    it 'should redirect to current user' do
      logged_in_user = stub("logged_in_user", :admin? => false)
      logged_in_user.stubs(:id).returns(42)
      login_as(logged_in_user)

      get :current
      assert_redirected_to user_path(:id => logged_in_user.id)
    end
  end


  describe "restore" do
    before :each do
      @email = "test@email#{Time.now.to_i}"
      @password = "BigPassword#{Time.now.to_i}"
      @user.stubs(:full_name).returns("Test User")
    end

    it "should resend activation if user not activated" do
      User.expects(:find_by_email).with(@email).returns(@user)
      @user.expects(:active?).returns(false)
      post :restore, :email => @email
    end

    it "should update user password if user activated" do
      User.expects(:find_by_email).with(@email).returns(@user)
      controller.expects(:random_pronouncable_password).returns(@password)
      @user.expects(:active?).returns(true)
      @user.expects(:password=).with(@password)
      @user.expects(:password_confirmation=).with(@password)
      @user.stubs(:password).returns(@password)
      @user.expects(:save)

      post :restore, :email => @email
    end

    it "should properly work if user not exists" do
      User.expects(:find_by_email).with(@email).returns(nil)
      post :restore, :email => @email
    end
  end
end
