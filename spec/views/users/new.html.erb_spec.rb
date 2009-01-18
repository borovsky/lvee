require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/new.html.erb" do
  before(:each) do
    assigns[:user] = model_stub(User,
      :new_record? => true,
      :errors => [],
      :password => '123',
      :password_confirmation => '123'
    )
  end

  it "should render new form" do
    render "/users/new.html.erb"

    response.should have_tag("form[action=?][method=post]", users_path) do
    end
  end
end
