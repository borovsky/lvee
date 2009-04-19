require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wiki_pages/show.html.erb" do
  before(:each) do
    assigns[:wiki_page] = @wiki_page = model_stub(WikiPage,
      :name => "value for name",
      :body => "value for body"
    )
  end

  it "should render attributes in <p>" do
    render "/wiki_pages/show.html.erb"
    response.should have_tag("h1", "value for name")
    response.should have_text(/value\ for\ body/)
  end
end
