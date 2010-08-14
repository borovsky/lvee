require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wiki_pages/index.html.erb" do

  before(:each) do
    assign :wiki_pages, [
      stub_model(WikiPage,
        :name => "value for name",
        :user => mock(:full_name => "value for user")),
      stub_model(WikiPage,
        :name => "value for name",
        :user =>mock(:full_name => "value for user"))]
  end

  it "should render list of wiki_pages" do
    render
    rendered.should have_selector("tr>td", :content => "value for name", :count => 2)
    rendered.should have_selector("tr>td", :content => "value for user", :count => 2)
  end
end
