require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/languages/index.html.erb" do
  before(:each) do
    assigns[:languages] = [
      model_stub(Language),
      model_stub(Language)
    ]
  end

  it "should render list of languages" do
    render "/editor/languages/index.html.erb"
  end
end
