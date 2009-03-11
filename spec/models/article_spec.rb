require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Article do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :body => "value for body",
      :category => "value for category",
      :name => "value for name",
      :locale => "value for locale"
    }
  end

  it "should create a new instance given valid attributes" do
    Article.create!(@valid_attributes)
  end
end
