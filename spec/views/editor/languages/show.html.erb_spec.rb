require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/languages/show.html.erb" do
  before(:each) do
    assigns[:language] = @language = model_stub(Language)
  end

  it "should render attributes in <p>" do
    render "/editor/languages/show.html.erb"
  end
end
