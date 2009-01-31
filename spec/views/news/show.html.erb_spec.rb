require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news/show.html.erb" do
  before(:each) do
    assigns[:news] = @news = model_stub(News,
      :title => 'xyz',
      :created_at => Time.new,
      :user => stub(:full_name => "Test User")
      )
  end

  it "should render" do
    render "/news/show.html.erb"
  end
end
