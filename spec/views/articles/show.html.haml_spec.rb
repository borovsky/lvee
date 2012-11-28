require 'spec_helper'

describe "articles/show" do
  before(:each) do
    @article = stub_model(Article,
      :title => "value for title",
      :body => "value for body"
    )
    assign(:article, @article)
  end

  it "should render attributes in <p>" do
    view.stub!(:editor?).and_return(true)
    
    render
    rendered.should have_selector("h1", :content => "value for title")
    rendered.should match(/value\ for\ body/)
  end
end
