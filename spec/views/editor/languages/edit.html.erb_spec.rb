require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/languages/edit.html.erb" do
  before(:each) do
    assigns[:language] = @language = model_stub(Language,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/editor/languages/edit.html.erb"

    response.should have_tag("form[action=#{editor_language_path(:id => @language)}][method=post]") do
    end
  end
end
