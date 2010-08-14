require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wiki_pages/edit.html.erb" do

  before(:each) do
    @wiki_page = stub_model(WikiPage,
      :new_record? => false,
      :body => "value for body",
      :name => "value for name"
    )
    assign :wiki_page, @wiki_page
  end

  it "should render edit form" do
    render

    rendered.should have_selector("form[method=post]", :action => wiki_page_path(:id => @wiki_page.name, :lang => "en")) do |n|
      n.should have_selector('textarea#wiki_page_body', :name => "wiki_page[body]")
      n.should have_selector('input#wiki_page_name', :name => "wiki_page[name]")
    end
  end
end
