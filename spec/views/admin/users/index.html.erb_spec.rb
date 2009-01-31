require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/languages/show.html.erb" do
  before(:each) do
    assigns[:users] = [model_stub(User, :full_name => "x y"), 
      model_stub(User, :full_name => "a b")]
  end

  it "should render attributes in <p>" do
    render "/admin/users/index.html.erb"
  end
end
