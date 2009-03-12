require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/articles/show.html.erb" do
  before(:each) do
    assigns[:article] = @article = model_stub(Article,
      :title => "value for title",
      :body => "value for body"
    )
  end

  it "should render attributes in <p>" do
    render "/articles/show.html.erb"
    response.should have_tag("h1", "value for title")
    response.should have_text(/value\ for\ body/)
  end
end
