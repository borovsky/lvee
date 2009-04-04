require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sponsor do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :url => "value for url",
      :image => "value for image"
    }
  end

  it "should create a new instance given valid attributes" do
    Sponsor.create!(@valid_attributes)
  end
end
