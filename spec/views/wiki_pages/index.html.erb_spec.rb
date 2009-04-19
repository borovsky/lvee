require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wiki_pages/index.html.erb" do

  before(:each) do
    assigns[:wiki_pages] = [
      model_stub(WikiPage,
        :name => "value for name",
        :user =>mock(:full_name => "value for user")
      ),
      model_stub(WikiPage,
        :name => "value for name",
        :user =>mock(:full_name => "value for user")
      )
    ]
  end

  it "should render list of wiki_pages" do
    render "/wiki_pages/index.html.erb"
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for user".to_s, 2)
  end
end
