require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wiki_pages/show.html.erb" do
  before(:each) do
    @wiki_page = stub_model(WikiPage,
      :name => "value for name",
      :body => "value for body"
    )
    assign(:wiki_page, @wiki_page)
  end

  it "should render attributes in <p>" do
    render #"/wiki_pages/show"
    response.should have_tag("h1", "value for name")
    response.should have_text(/value\ for\ body/)
  end
end
