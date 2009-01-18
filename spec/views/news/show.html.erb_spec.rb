require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news/show.html.erb" do
  before(:each) do
    assigns[:news] = @news = model_stub(News,
      :title => 'xyz',
      :created_at => Time.new
      )
  end

  it "should render attributes in <p>" do
    render "/news/show.html.erb"
  end
end
