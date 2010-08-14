require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::InfoMailerController do
  def mock_user(stubs={})
    stub_model(User, stubs)
  end

  before :each do
    @user1 = mock_user(:id => 1, :email => "test1", :full_name => "FullName1")
    @user2 = mock_user(:id => 2, :email => "test1", :full_name => "FullName2")
    @user3 = mock_user(:id => 3, :email => "test1", :full_name => "FullName3")

    @admin = mock_user(:id => 42, :login => "test", :role => "admin")
    login_as @admin
    ActionMailer::Base.deliveries = []
  end

  describe "index" do
    render_views

    it "should render properly" do
      get :index, :to_list => "1,2,3,4"

      assert_response :success
    end

    it "should render properly with multibly TOs" do
      User.should_receive(:find_by_id).with('1').and_return(@user1)
      User.should_receive(:find_by_id).with('2').and_return(@user2)
      User.should_receive(:find_by_id).with('3').and_return(@user3)
      User.should_receive(:find_by_id).with('4').and_return(nil)

      get :index, :to_list => '1,2,3,4'
      assert_response :success
      assigns[:to_list].should == [1, 2, 3]
    end
  end

  describe "send_mail" do
    render_views

    it "should render properly" do
      post :send_mail, :to => "test", :subject => "subjectTest", :body => "BodyTest"
      assert_response :success

      emails = ActionMailer::Base.deliveries
      emails.length.should == 1
      email = emails.first

      email.subject.should == "subjectTest"
      email.to[0].should == "test"
      email.body.should match(/BodyTest/)
    end

    it "should render properly with multibly TOs" do
      User.should_receive(:find_by_id).with('1').and_return(@user1)
      User.should_receive(:find_by_id).with('2').and_return(@user2)
      User.should_receive(:find_by_id).with('3').and_return(@user3)
      User.should_receive(:find_by_id).with('4').and_return(nil)

      get :send_mail, :to_list => '1,2,3,4', :subject => "subjectTest", :body => "BodyTest"
      assert_response :success

      assigns[:to_list].should == [1, 2, 3]

      emails = ActionMailer::Base.deliveries
      emails.length.should == 3

      users = [@user1, @user2, @user3]

      emails.each_with_index do |email, idx|
        email.subject.should == "subjectTest"
        email.to[0].should == users[idx].email
        email.body.should match(/BodyTest/)
      end
    end

    it "should render properly with multibly TOs" do
      User.should_receive(:find_by_id).with('1').and_return(@user1)
      User.should_receive(:find_by_id).with('2').and_return(@user2)
      User.should_receive(:find_by_id).with('3').and_return(@user3)

      put :send_mail, :to_list => '1,2,3', :subject => "subjectTest", :body => "Test {{user}}"
      assert_response :success

      emails = ActionMailer::Base.deliveries
      emails.length.should == 3

      users = [@user1, @user2, @user3]

      emails.each_with_index do |email, idx|
        email.subject.should == "subjectTest"
        email.to[0].should == users[idx].email
        email.body.should be_include(users[idx].full_name)
      end
    end
  end
end
