require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sponsor do
  before(:each) do
    file = File.join(RAILS_ROOT, "public", "images", "logos", 'mlug.gif')
    @valid_attributes = {
      :name => "value for name",
      :url => "value for url",
      :image => ActionController::TestUploadedFile.new(file, nil, true)
    }
  end

  it "should create a new instance given valid attributes" do
    Sponsor.create!(@valid_attributes)
  end
end
