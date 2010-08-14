require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/editor/languages/index.html.erb" do
  before(:each) do
    assign :languages, [
      stub_model(Language),
      stub_model(Language)
    ]
  end

  it "should render list of languages" do
    render
  end
end
