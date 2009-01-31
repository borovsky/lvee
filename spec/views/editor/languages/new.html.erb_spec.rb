require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/languages/new.html.erb" do
  before(:each) do
    assigns[:language] = model_stub(Language,
      :new_record? => true
    )
  end

  it "should render new form" do
    render "/editor/languages/new.html.erb"

    response.should have_tag("form[action=?][method=post]", editor_languages_path) do
    end
  end
end
