require 'spec_helper'

describe "Editor::Translations" do
  describe "GET /en/editor_translations" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get editor_translations_path(lang: "by")
      #response.status.should be(200)
    end
  end
end
