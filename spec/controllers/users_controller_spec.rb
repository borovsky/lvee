#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  def mock_user(stubs={})
    model_stub(User, stubs)
  end

  before :all do
    @user = mock_user(:id => 100)
    @admin = mock_user(:id => 1, :admin? => true)
  end

  describe 'new' do
    it "should be accessible by right URL" do
      params_from(:get, '/ru/users/new').should == {
        :controller => 'users',
        :action => 'new',
        :lang=>'ru'
      }
    end
  end

  describe 'create' do
    it "should be accessible by right URL" do
      params_from(:post, '/ru/users').should == {
        :controller => 'users',
        :action => 'create',
        :lang=>'ru'
      }
    end
    it "shouldn't save invalid user" do
      lambda {
        post :create
      }.should change {User.count}.by(0)
    end

    it "should create user" do
      UserMailer.stubs(:deliver_signup_notification).returns(nil)
      lambda {
        post :create, :user => User.valid_data
      }.should change {User.count}.by(1)
    end
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
      logged_in_user = stub(:logged_in_user)
      logged_in_user.stubs(:id).returns(42)
      login_as(logged_in_user)

      user = stub(:user)
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

  describe 'edit' do
    it "should be accessible by right URL" do
      params_from(:get, '/ru/users/42/edit').should == {
        :controller => 'users',
        :action => 'edit',
        :id=>'42',
        :lang => 'ru'
      }
    end

    it 'accessible only for logged in user' do
      @controller.stubs(:logged_in?).returns(false)
      get :edit, :id=> '42'
      assert_redirected_to new_session_path
    end

    it "should edit current user" do
      logged_in_user = stub(:logged_in_user)
      logged_in_user.stubs(:id).returns(42)
      login_as(logged_in_user)

      user = stub(:user)
      User.stubs(:find).with('42').returns(user)

      user.stubs(:editable_by?).with(logged_in_user).returns(true)

      get :edit, :id=> '42'
      assert_response :success
      assigns(:user).should == user
    end

    it "should forbid edit other user" do
      logged_in_user = stub(:logged_in_user)
      logged_in_user.stubs(:id).returns(1234)
      login_as(logged_in_user)

      user = stub(:user)
      User.stubs(:find).with('42').returns(user)
      user.stubs(:editable_by?).with(logged_in_user).returns(false)

      get :edit, :id=> '42'
      assert_response 403
    end
  end

  describe "update" do
    it "should be accessible by right URL" do
      params_from(:put, '/be/users/42').should == {
        :controller => 'users',
        :action => 'update',
        :id=>'42',
        :lang => 'be'
      }
    end

    it "should update current user" do
      user = User.new(User.valid_data)
      user.save!

      logged_in_user = stub(:logged_in_user)
      logged_in_user.stubs(:id).returns(user.id)
      login_as(logged_in_user)

      post :update, :id=>user.id, :user=>User.valid_data
      assert_redirected_to user_path(:id=>user)
    end

    it "should forbid update other user" do
      user = User.new(User.valid_data)
      user.save!

      logged_in_user = stub(:logged_in_user)
      logged_in_user.stubs(:id).returns(user.id+1)
      logged_in_user.stubs(:to_s).returns((user.id+1).to_s)
      login_as(logged_in_user)

      post :update, :id=>user.id, :user=>User.valid_data
      assert_response 403
    end

    it "shouldn't update current user with incorrect data" do
      user = User.new(User.valid_data)
      user.save!

      logged_in_user = stub(:logged_in_user)
      logged_in_user.stubs(:id).returns(user.id)
      login_as(logged_in_user)

      post :update, :id=>user.id, :user=>{:first_name=>'x'}
      assert_response :success
      assert_template 'users/edit'
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
      logged_in_user = stub(:logged_in_user)
      logged_in_user.stubs(:id).returns(42)
      login_as(logged_in_user)

      get :current
      assert_redirected_to user_path(:id => logged_in_user.id)
    end

  end

end
