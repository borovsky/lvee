require 'spec_helper'
require 'pdf_export'


describe PdfExport do
  context "#badges" do
    it "should generate pdf" do
      pending
      cr = FactoryGirl.create :conference_registration, :with_badges, number_of_badges: 100
      PdfExport.badges(cr.badges, nil).should_not be_nil
    end
  end
end
