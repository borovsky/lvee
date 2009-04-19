require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wiki_pages/edit.html.erb" do

  before(:each) do
    assigns[:wiki_page] = @wiki_page = model_stub(WikiPage,
      :new_record? => false,
      :body => "value for body",
      :name => "value for name"
    )
  end

  it "should render edit form" do
    render "/wiki_pages/edit.html.erb"

    response.should have_tag("form[action=#{wiki_page_path(:id => @wiki_page.name)}][method=post]") do
      with_tag('textarea#wiki_page_body[name=?]', "wiki_page[body]")
      with_tag('input#wiki_page_name[name=?]', "wiki_page[name]")
    end
  end
end
