require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/editor/languages/edit.html.erb" do
  before(:each) do
    @language = stub_model(Language,
      :new_record? => false
    )
    assign :language, @language
  end

  it "should render edit form" do
    render

    rendered.should have_selector("form[method=post]", :action => editor_language_path(:id => @language, :lang => "en"))
  end
end
