require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sponsor do
  before(:each) do
    file = File.join(::Rails.root, "public", "images", "logos", 'mlug.gif')
    @valid_attributes = {
      :name => "value for name",
      :url => "value for url",
      :image => Rack::Utils::Multipart::UploadedFile.new(file, nil, true),
      :sponsor_type => "information"
    }
  end

  it "should create a new instance given valid attributes" do
    Sponsor.create!(@valid_attributes)
  end
end
