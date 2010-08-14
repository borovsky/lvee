require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/editor/languages/show.html.erb" do
  before(:each) do
    @language = stub_model(Language)
    assign :language, @language
  end

  it "should render attributes in <p>" do
    render
  end
end
