require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/editor/languages/new.html.erb" do
  before(:each) do
    assign :language, stub_model(Language,
      :new_record? => true
    )
  end

  it "should render new form" do
    render

    rendered.should have_selector("form[method=post]", :action => editor_languages_path(:lang => "en")) do
    end
  end
end
