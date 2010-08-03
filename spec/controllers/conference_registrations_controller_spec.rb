require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConferenceRegistrationsController do
  render_views

  #Delete this example and add some real ones
  it "should show new page" do
    user = model_stub(User, :editor? => false, :id => 2, :admin? => false)

    conference = model_stub(Conference, :name => "Test Conference")

    login_as user

    User.stubs(:find).with(2).returns(user)
    Conference.stubs(:find).with('42').returns(conference)
    get :new, :user_id => 2, :conference_id => 42


  end

end
