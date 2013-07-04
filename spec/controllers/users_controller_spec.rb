#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  def mock_user(stubs={})
    stub_model(User, stubs)
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  describe 'activate' do
    it 'should activate user for specified code' do
      user = mock()
      User.should_receive(:find_by_activation_code).with('42').and_return(user)
      user.should_receive(:active?).and_return(false)
      user.should_receive(:activate)
      user.should_receive(:id).and_return(69)
      user.should_receive(:to_s).and_return('69')
      get :activate, :activation_code => '42'
      assert_redirected_to '/en/users/69'
    end

    it 'should redirect to root if user with activation_code not found' do
      User.should_receive(:find_by_activation_code).with('42').and_return(nil)
      get :activate, :activation_code => '42'
      assert_redirected_to '/'
    end

    it 'should redirect to root if user already active' do
      user = mock()
      User.should_receive(:find_by_activation_code).with('42').and_return(user)
      user.should_receive(:active?).and_return(true)
      get :activate, :activation_code => '42'
      assert_redirected_to '/'
    end
  end

  describe 'show' do
    it 'accessible only for logged in user' do
      get :show, id: '42'
      assert_redirected_to new_session_path
    end

    it 'can show current user' do
      logged_in_user = stub("logged_in_user", :admin? => false)
      logged_in_user.stub!(:id).and_return(42)
      login_as(logged_in_user)

      user = stub(:user, id: 42)
      User.stub!(:find).with('42').and_return(user)

      get :show, id: '42'
      assert_response :success
      assigns(:user).should == user
    end

    it "can't show other users" do
      logged_in_user = mock_user(:id => 1234, :admin? => false)
      login_as(logged_in_user)

      user = mock_user()
      User.stub!(:find).with('42').and_return(user)

      get :show, :id=> '42'
      assert_response 403
    end


    it 'admin can view any user' do
      login_as admin

      get :show, id: user.id.to_s
      assert_response :success
      assigns(:user).should == user
    end
  end

  describe "edit" do
    it "should be accessible for current user" do
      login_as user

      get :edit, id: user.id.to_s
      assert_response :success
    end


    it "should not be  accessible for other user" do
      login_as user

      User.stub!(:find).with('42').and_return(user)
      controller.stub!(:edit).and_return(true)

      get :edit, id: '42'
      assert_response 403
    end
  end

  describe "current" do
    it 'accessible only for logged in user' do
      get :current
      assert_redirected_to new_session_path
    end

    it 'should redirect to current user' do
      logged_in_user = stub("logged_in_user", :admin? => false)
      logged_in_user.stub!(:id).and_return(42)
      login_as(logged_in_user)

      get :current
      assert_redirected_to user_path(:id => logged_in_user.id)
    end
  end


  describe "restore" do
    before :each do
      @email = "test@email#{Time.now.to_i}"
      @password = "BigPassword#{Time.now.to_i}"
    end

    it "should resend activation if user not activated" do
      User.should_receive(:find_by_email).with(@email).and_return(user)
      user.should_receive(:active?).and_return(false)
      post :restore, :email => @email
    end

    it "should update user password if user activated" do
      User.should_receive(:find_by_email).with(@email).and_return(user)
      controller.should_receive(:random_pronouncable_password).and_return(@password)
      user.should_receive(:active?).and_return(true)
      user.should_receive(:password=).with(@password)
      user.should_receive(:password_confirmation=).with(@password)
      user.stub!(:password).and_return(@password)
      user.should_receive(:save)

      post :restore, :email => @email
    end

    it "should properly work if user not exists" do
      User.should_receive(:find_by_email).with(@email).and_return(nil)
      post :restore, :email => @email
    end
  end
end
