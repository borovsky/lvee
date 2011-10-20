require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wiki_pages/new" do

  before(:each) do
    @page = WikiPage.new(:body => "value for body", :name => "value for subcategory")
    assign :wiki_page, @page
  end

  it "should render new form" do
    render

    rendered.should have_selector("form[method=post]", :action => wiki_pages_path) do |n|
      n.should have_selector("textarea#wiki_page_body", :name => "wiki_page[body]")
      n.should have_selector("input#wiki_page_name", :name => "wiki_page[name]")
    end
  end
end
