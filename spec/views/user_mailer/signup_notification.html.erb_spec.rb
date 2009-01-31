require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news/show.html.erb" do
  before(:each) do
    assigns[:user] = @user = model_stub(User,
      :full_name => 'xyz'
      )
    assigns[:url] = @url = "http://lvee.org"
  end

  it "should render" do
    render "/user_mailer/activation.html.erb"
  end
end
