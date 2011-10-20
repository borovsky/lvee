require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news/show.html.haml" do
  helper :application

  before(:each) do
    @news = stub_model(News,
      :title => 'xyz',
      :created_at => Time.new,
      :user => stub_model(User, :full_name => "Test User")
      )
    assign :news, @news
  end

  it "should render" do
    view.stub(:editor?).and_return(true)
    view.stub(:admin?).and_return(true)
    render
  end
end
