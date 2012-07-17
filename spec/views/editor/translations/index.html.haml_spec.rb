require 'spec_helper'

describe "editor/translations/index" do
  before(:each) do
    assign(:editor_translations, [
      stub_model(Editor::Translation),
      stub_model(Editor::Translation)
    ])
  end

  it "renders a list of editor/translations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
