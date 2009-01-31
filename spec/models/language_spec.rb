require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Language do
  before(:each) do
    @valid_attributes = {
      :name=> 'ru',
      :description => 'Russian',
      :published => false
    }
  end

  it "should create a new instance given valid attributes" do
    Language.create!(@valid_attributes)
  end
end
