require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/edit.html.erb" do
  before(:each) do
    assigns[:user] = @user = model_stub(User,
      :new_record? => true,
      :errors => [],
      :full_name => 'xyz',
      :password => '123',
      :password_confirmation => '123'
    )
  end

  it "should render new form" do
    
    template.stubs(:current_user).returns(assigns[:user])
    render "/users/edit.html.erb"

    response.should have_tag("form[action=?][method=post]", user_path(@user)) do
    end
  end
end
