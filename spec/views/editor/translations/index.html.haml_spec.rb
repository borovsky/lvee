require 'spec_helper'

describe "editor/translations/index" do
  before(:each) do
    assign(:original_translations,
           [
            stub_model(Translation, key: "label.common.new"),
            stub_model(Translation, key: "label.common.back"),
           ])
    assign(:translations, {})
  end

  it "renders a list of editor/translations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
