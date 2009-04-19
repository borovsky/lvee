require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wiki_pages/new.html.erb" do

  before(:each) do
    assigns[:wiki_page] = model_stub(WikiPage,
      :new_record? => true,
      :body => "value for body",
      :name => "value for subcategory"
    )
  end

  it "should render new form" do
    render "/wiki_pages/new.html.erb"

    response.should have_tag("form[action=?][method=post]", wiki_pages_path) do
      with_tag("textarea#wiki_page_body[name=?]", "wiki_page[body]")
      with_tag("input#wiki_page_name[name=?]", "wiki_page[name]")
    end
  end
end
