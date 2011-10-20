require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wiki_pages/diff" do
  before(:each) do
    @wiki_page = stub_model(WikiPage,
      :body => "value for body",
      :name => "value for name",
      :version => 1,
      :versions => []
      )
    assign :wiki_page, @wiki_page
    @prev = stub_model(WikiPage,
      :body => "prev value for body",
      :name => "value for name"
      )
    assign :prev, @prev

    controller.stub!(:display_diff).with(@prev, @wiki_page, :render_wiki_page).and_return("Test")
  end

  it "should render edit form" do
    render
  end
end
