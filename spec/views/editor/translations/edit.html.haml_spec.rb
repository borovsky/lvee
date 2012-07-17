require 'spec_helper'

describe "editor/translations/edit" do
  before(:each) do
    @editor_translation = assign(:editor_translation, stub_model(Editor::Translation))
  end

  it "renders the edit editor_translation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => editor_translations_path(@editor_translation), :method => "post" do
    end
  end
end
