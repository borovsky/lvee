require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/conferences/index.html.erb" do
  before(:each) do
    assigns[:conferences] = [
      model_stub(Conference),
      model_stub(Conference)
    ]
  end

  it "should render list of conferences" do
    render "/admin/conferences/index.html.erb"
  end
end
