require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConferenceRegistrationsController do
  render_views

  #Delete this example and add some real ones
  it "should show new page" do
    user = stub_model(User, :role? => "", :id => 2)

    conference = stub_model(Conference, :name => "Test Conference", :id => 42)

    login_as user

    User.stub!(:find).with('2').and_return(user)
    Conference.stub!(:find).with('42').and_return(conference)
    get :new, :user_id => '2', :conference_id => '42'
  end

end
