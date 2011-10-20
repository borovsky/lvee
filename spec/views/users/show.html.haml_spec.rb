require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/show.html" do
  helper :users

  before(:each) do
    @user = stub_model(User,
      :full_name => 'xyz',
      :role => "admin")
    assign :user, @user
  end

  it "should render new form" do
    view.stub!(:current_user).and_return(@user)
    render
  end
end
