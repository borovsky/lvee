require 'spec_helper'

describe Site do
  it {should validate_presence_of :file}
  context "#save" do
    it "should check if file is correct ZIP archive"
    it "should unpack archive"
    it "should remove old files"
  end

  context "#destroy" do
    it "should cleanup directory"
  end
end
