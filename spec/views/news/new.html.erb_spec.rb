require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news/new.html.erb" do
  before(:each) do
    assigns[:news] = model_stub(News,
      :new_record? => true,
      :errors => []
    )
  end

  it "should render new form" do
    template.stubs(:current_user=>model_stub(User, :site_editor? => true))
    render "/news/new.html.erb"

    response.should have_tag("form[action=?][method=post]", news_path) do
    end
  end
end
