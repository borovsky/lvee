require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/show.html.erb" do
  include ActionView::Helpers::TextHelper

  before(:each) do
    assigns[:user] = model_stub(User,
      :new_record? => true,
      :errors => [],
      :full_name => 'xyz',
      :editor? => true,
      :admin? => true
      )
  end

  it "should render new form" do
    template.stubs(:current_user).returns(assigns[:user])
    render "/users/show.html.erb"
  end
end
