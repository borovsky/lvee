require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/conferences/show.html.erb" do
  before(:each) do
    assigns[:conference] = @conference = model_stub(Conference)
  end

  it "should render attributes in <p>" do
    render "/admin/conferences/show.html.erb"
  end
end
