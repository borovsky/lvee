#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do

  describe 'new' do
    integrate_views

    it "should open by guest" do
      get :new
      assert_response :success
    end
  end

  describe 'create' do
    before :all do
      @u = User.new(User.valid_data)
    end

    it 'should login user if authenticated' do
      User.expects(:authenticate).with("user", "password").returns(@u)
      @u.stubs(:id).returns(42)
      post :create, :login => "user", :password=> "password"
      assert_redirected_to '/en/users/42'
    end

    it 'should login user and remember me if "remeber me" checked' do
      User.expects(:authenticate).with("user", "password").returns(@u)
      @u.expects(:remember_token?).returns(false)
      @u.expects(:remember_me)
      time = 42.days.from_now.utc
      @u.expects(:remember_token).returns('test')
      @u.expects(:remember_token_expires_at).returns(time)
      @u.stubs(:id).returns(42)

      post :create, :login => "user", :password=> "password", :remember_me => '1'
      assert_redirected_to '/en/users/42'
      cookies[:auth_token].value.should == ["test"]
      cookies[:auth_token].expires.should == time
    end

    it "shouldn't login if authentication error" do
      User.expects(:authenticate).with("user", "password").returns(false)
      post :create, :login => "user", :password=> "password"
      assert_response :success
      assert_template "new"
    end
  end

  describe 'destroy' do
    it 'should logout user' do
      user = stub()
      user.expects(:forget_me)
      login_as user
      @controller.expects(:reset_session)
      delete :destroy
      assert_redirected_to '/'
      assert flash[:notice]
    end

    it 'should delete authentication token' do
      user = stub()
      user.expects(:forget_me)
      login_as user
      cookies[:auth_token] = 'test'
      @controller.expects(:reset_session)
      delete :destroy

      cookies[:auth_token].should be_empty
    end
  end
end
