require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "users/show.html.haml" do
  helper :users

  before(:each) do
    @user = stub_model(User,
                       :full_name => 'xyz',
                       :role => "admin")
    assign :user, @user
    assign :available_conferences, []
    assign :current_registrations, []
    assign :participated_conferences, []
  end

  it "should render" do
    view.stub!(:current_user).and_return(@user)
    render
  end
end
