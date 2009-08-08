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
      n.expects(:published_at=)
      n.publish
    end

    it "should set published_at to now plus 1 day" do
      n = News.new
      now = Time.new
      Time.stubs(:now).returns(now)
      n.expects(:published_at=).with(now + 1.day)
      n.publish
    end

    it "should save news" do
      state = states('state').starts_as('not published')
      n = News.new
      n.expects(:published_at=).then(state.is('publish set'))
      n.expects(:save).when(state.is('publish set'))
      n.publish
    end
  end

  describe "publish_now" do
    it "should set published_at" do
      n = News.new
      n.expects(:published_at=)
      n.publish_now
    end

    it "should set published_at to now" do
      n = News.new
      now = Time.new
      Time.stubs(:now).returns(now)
      n.expects(:published_at=).with(now)
      n.publish_now
    end

    it "should save news" do
      state = states('state').starts_as('not published')
      n = News.new
      n.expects(:published_at=).then(state.is('publish set'))
      n.expects(:save).when(state.is('publish set'))
      n.publish_now
    end
  end
end
