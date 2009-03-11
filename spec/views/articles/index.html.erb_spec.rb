require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/articles/index.html.erb" do
  include ArticlesHelper

  before(:each) do
    assigns[:articles] = [
      model_stub(Article,
        :title => "value for title",
        :body => "value for body",
        :category => "value for category",
        :name => "value for name"
      ),
      model_stub(Article,
        :title => "value for title",
        :body => "value for body",
        :category => "value for category",
        :name => "value for name"
      )
    ]
  end

  it "should render list of articles" do
    render "/articles/index.html.erb"
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for category".to_s, 2)
    response.should have_tag("tr>td", "value for name".to_s, 2)
  end
end
