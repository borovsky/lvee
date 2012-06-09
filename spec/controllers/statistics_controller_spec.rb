require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StatisticsController do

  describe "index" do
    it "should be successful" do
      get 'access'
      response.should be_success
    end
  end

  describe "conference" do
    before :each do
      @conference = Conference.create!(:name => "LVEE 2009")
      @user1 = User.create!(User.valid_data.merge(login: "test1", email: "test1@a.com"))
      @user2 = User.create!(User.valid_data.merge(login: "test2", email: "test2@a.com"))
      @user3 = User.create!(User.valid_data.merge(login: "test3", email: "test3@a.com", country: "Russia"))
      @reg1 = ConferenceRegistration.create!(:user_id => @user1.id, :conference_id => @conference.id, :quantity => 1)
      @reg2 = ConferenceRegistration.create!(:user_id => @user2.id, :conference_id => @conference.id, :quantity => 3)
      @reg3 = ConferenceRegistration.create!(:user_id => @user3.id, :conference_id => @conference.id, :quantity => 2)
    end

    it "should be successful" do

      get 'conference', :id => "LVEE 2009"
      response.should be_success

      assigns[:conference].should == @conference
      assigns[:registrations].length.should == 3
      assigns[:countries].length.should == 2
      assigns[:countries].first.first.should == "Belarus"
      assigns[:countries].first.second.should == 4
      assigns[:countries].second.first.should == "Russia"
      assigns[:countries].second.second.should == 2
    end
  end
end
