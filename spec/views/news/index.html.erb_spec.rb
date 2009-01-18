require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news/index.html.erb" do
  before(:each) do
    user = model_stub(User, :full_name=>'Vasily Pupkin')
    assigns[:news] = [
      model_stub(News, :user=> user, :title => 'xyz', :lead => 'abc'),
      model_stub(News, :user=> user, :title => 'xyz', :lead => 'abc')
    ]
  end

  it "should render list of news" do
    template.stubs(:current_user=>model_stub(User, :site_editor? => true))
    render "/news/index.html.erb"
  end
end
