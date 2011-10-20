require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/articles/index.html" do

  before(:each) do
    assign :articles, [
      stub_model(Article,
        :title => "value for title",
        :body => "value for body",
        :category => "value for category",
        :name => "value for name"
      ),
      stub_model(Article,
        :title => "value for title",
        :body => "value for body",
        :category => "value for category",
        :name => "value for name"
      )
    ]
  end

  it "should render list of articles" do
    render
    rendered.should have_selector("tr>td", :content => "value for title", :count => 2)
    rendered.should have_selector("tr>td", :content => "value for category", :count => 2)
    rendered.should have_selector("tr>td", :content => "value for name", :count => 2)
  end
end
