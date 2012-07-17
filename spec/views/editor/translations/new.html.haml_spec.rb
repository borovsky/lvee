require 'spec_helper'

describe "editor/translations/new" do
  before(:each) do
    assign(:editor_translation, stub_model(Editor::Translation).as_new_record)
  end

  it "renders new editor_translation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => editor_translations_path, :method => "post" do
    end
  end
end
