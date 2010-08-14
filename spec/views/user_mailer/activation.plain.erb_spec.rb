require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/user_mailer/activation.plain.erb" do
  before(:each) do
    @user = stub_model(User,
      :full_name => 'xyz',
      :login => 'login',
      :password => 'pass'
      )
    assign :user, @user
    @url = "http://lvee.org"
    assign :url, @url
  end

  it "should render" do
    render
  end
end
