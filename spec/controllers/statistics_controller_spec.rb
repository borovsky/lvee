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
      @user1 = User.create!(User.valid_data.merge(:login => "test1"))
      @user2 = User.create!(User.valid_data.merge(:login => "test2"))
      @user3 = User.create!(User.valid_data.merge(:login => "test3", :country => "Russia"))
      @reg1 = ConferenceRegistration.create!(:user => @user1, :conference => @conference, :quantity => 1)
      @reg2 = ConferenceRegistration.create!(:user => @user2, :conference => @conference, :quantity => 3)
      @reg3 = ConferenceRegistration.create!(:user => @user3, :conference => @conference, :quantity => 2)
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
