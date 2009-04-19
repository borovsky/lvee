require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wiki_pages/diff.html.erb" do
  before(:each) do
    assigns[:wiki_page] = @wiki_page = model_stub(WikiPage,
      :body => "value for body",
      :name => "value for name",
      :version => 1,
      :versions => []
      )
    assigns[:prev] = @prev = model_stub(WikiPage,
      :body => "prev value for body",
      :name => "value for name"
      )
    @controller.stubs(:display_diff).with(@prev, @wiki_page, :render_wiki_page).returns("Test")
  end

  it "should render edit form" do
    render "/wiki_pages/diff.html.erb"
  end
end
