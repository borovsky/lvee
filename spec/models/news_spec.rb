require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe News do
  before(:each) do
    @valid_attributes = {
      :title => "title",
      :lead => "lead",
      :body => "body",
      :locale => "de"
    }
  end

  it "should create a new instance given valid attributes" do
    News.create!(@valid_attributes)
  end

  describe "translation" do
    it "only one allowed" do
      n_parent = News.new(@valid_attributes)
      n_parent.save!

      n1 = News.new(@valid_attributes)
      n1.parent_id = n_parent.id
      n1.locale = 'de'
      n1.save!

      n2 = News.new(@valid_attributes)
      n2.parent_id = n_parent.id
      n2.locale = 'de'
      n2.should_not be_valid
    end
  end

  describe "publish" do
    it "should set published_at" do
      n = News.new
      n.should_receive(:published_at=)
      n.publish
    end

    it "should set published_at to now plus 1 day" do
      n = News.new
      now = Time.new
      Time.stub!(:now).and_return(now)
      n.should_receive(:published_at=).with(now + 1.day)
      n.publish
    end

    it "should save news" do
      n = News.new({:title => "1", :lead => "l", :body => "b", :user_id => 1, :locale => "en"}, 
                   without_protection: true)
      n.publish
      
      n2 = News.find(n.id)
      n2.published_at.to_s.should == n.published_at.to_s
    end
  end

  describe "publish_now" do
    it "should set published_at" do
      n = News.new
      n.should_receive(:published_at=)
      n.publish_now
    end

    it "should set published_at to now" do
      n = News.new
      now = Time.new
      Time.stub!(:now).and_return(now)
      n.should_receive(:published_at=).with(now)
      n.publish_now
    end

    it "should save news" do
      n = News.new
      n.should_receive(:published_at=).ordered
      n.should_receive(:save).ordered
      n.publish_now
    end
  end
end
