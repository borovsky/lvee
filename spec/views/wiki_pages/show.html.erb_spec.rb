require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "wiki_pages/show.html.erb" do
  before(:each) do
    @wiki_page = stub_model(WikiPage,
      :name => "value for name",
      :body => "value for body"
    )
    assign(:wiki_page, @wiki_page)

    view.stub!(:logged_in?).and_return(true)
  end

  it "should render attributes in <p>" do
    render
    rendered.should have_selector("h1", :content => "value for name")
    rendered.should match(/value\ for\ body/)
  end
end
