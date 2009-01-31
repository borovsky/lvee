require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/conferences/edit.html.erb" do
  before(:each) do
    assigns[:conference] = @conference = model_stub(Conference,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/admin/conferences/edit.html.erb"

    response.should have_tag("form[action=#{admin_conference_path(:id => @conference)}][method=post]") do
    end
  end
end
