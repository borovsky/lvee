require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/conferences/new.html.erb" do
  before(:each) do
    assigns[:conference] = model_stub(Conference,
      :new_record? => true
    )
  end

  it "should render new form" do
    render "/admin/conferences/new.html.erb"

    response.should have_tag("form[action=?][method=post]", admin_conferences_path) do
    end
  end
end
