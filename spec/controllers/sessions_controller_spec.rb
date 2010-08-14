require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do

  describe 'new' do
    render_views

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
      User.should_receive(:authenticate).with("user", "password").and_return(@u)
      @u.stub!(:id).and_return(42)
      post :create, :login => "user", :password=> "password"
      assert_redirected_to '/en/users/42'
    end

    it 'should login user and remember me if "remeber me" checked' do
      User.should_receive(:authenticate).with("user", "password").and_return(@u)
      @u.should_receive(:remember_token?).and_return(false)
      @u.should_receive(:remember_me)
      time = 42.days.from_now.utc
      @u.should_receive(:remember_token).and_return('test')
      @u.should_receive(:remember_token_expires_at).and_return(time)
      @u.stub!(:id).and_return(42)

      post :create, :login => "user", :password=> "password", :remember_me => '1'
      assert_redirected_to '/en/users/42'
      cookies["auth_token"].should == "test"
    end

    it "shouldn't login if authentication error" do
      User.should_receive(:authenticate).with("user", "password").and_return(false)
      post :create, :login => "user", :password=> "password"
      assert_response :success
      assert_template "new"
    end
  end

  describe 'destroy' do
    it 'should logout user' do
      user = stub()
      user.should_receive(:forget_me)
      login_as user
      @controller.should_receive(:reset_session)
      delete :destroy
      assert_redirected_to '/'
      assert flash[:notice]
    end

    it 'should delete authentication token' do
      user = stub()
      user.should_receive(:forget_me)
      login_as user
      cookies[:auth_token] = 'test'
      @controller.should_receive(:reset_session)
      delete :destroy

      cookies[:auth_token].should be_blank
    end
  end
end
