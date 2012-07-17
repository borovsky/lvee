require 'spec_helper'

describe "editor/translations/show" do
  before(:each) do
    @editor_translation = assign(:editor_translation, stub_model(Editor::Translation))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
