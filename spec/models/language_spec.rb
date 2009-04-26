require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Language do
  before(:each) do
    @valid_attributes = {
      :name=> 'ru',
      :code3 => 'rus',
      :description => 'Russian',
      :published => false
    }
  end

  it "should create a new instance given valid attributes" do
    l = Language.new(@valid_attributes)
    l.name = @valid_attributes[:name]
    l.save!
  end
end
