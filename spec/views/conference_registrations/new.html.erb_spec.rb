require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/conference_registrations/new" do
  def mock_user(stubs={})
    model_stub(User, stubs)
  end

  before :all do
    @user=mock_user(:id => 1)
    @other_user=mock_user(:id => 2)
  end

  it "should render create form for registration" do
    conf1 = model_stub(Conference, :name => 'LVEE 2008', :start_date => Time.new, :finish_date => Time.new, :id => 42)
    reg = model_stub(ConferenceRegistration, :conference => conf1)
    login_as @user
    assigns[:registration] = reg
    params[:user_id] = '1'

    render 'conference_registrations/new'
    response.should have_tag("form[action=#{user_conference_registrations_path(:user_id =>@user.id)}][method=post]")
  end
end
