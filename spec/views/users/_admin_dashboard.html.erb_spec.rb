require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/_admin_dashboard.html.erb" do
  include ActionView::Helpers::TextHelper

  it "should render new form" do
    template.stubs(:current_user).returns(assigns[:user])
    render "/users/_admin_dashboard.html.erb"
  end
end
