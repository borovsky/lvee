require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news/_editor_actions.html.erb" do
  before(:each) do
    user = model_stub(User, :full_name=>'Vasily Pupkin')
  end

  describe "should render editor actions for news" do
    describe "if news not translated" do
      before(:each) do
        @news = model_stub(News, :translated? => false)
      end

      it "locale default" do
        locale = I18n.default_locale
        @news.stubs(:locale).returns(locale)
        I18n.stubs(:locale).returns(locale)

        render "/news/_editor_actions.html.erb", :locals => {:news => @news}
        response.should have_tag("a[href=#{edit_news_item_path(:id => @news.id)}]", "Edit")
      end

      it "locale default" do
        locale = I18n.default_locale + "other"
        @news.stubs(:locale).returns(locale)
        I18n.stubs(:locale).returns(I18n.default_locale)

        render "/news/_editor_actions.html.erb", :locals => {:news => @news}
        response.should have_tag("a[href=#{translate_news_path(:parent_id => @news.id, :locale =>I18n.default_locale )}]", "Translate")
      end
    end

    describe "if news translated" do
      before(:each) do
        @news = model_stub(News, :translated? => true)
      end

      it "locale default" do
        locale = I18n.default_locale
        @news.stubs(:locale).returns(locale)
        I18n.stubs(:locale).returns(locale)

        render "/news/_editor_actions.html.erb", :locals => {:news => @news}
        response.should have_tag("a[href=#{edit_news_item_path(:id => @news.id)}]", "Edit translation")
      end

      it "locale default" do
        locale = I18n.default_locale + "other"
        @news.stubs(:locale).returns(locale)
        I18n.stubs(:locale).returns(I18n.default_locale)

        render "/news/_editor_actions.html.erb", :locals => {:news => @news}
        response.should have_tag("a[href=#{edit_news_item_path(:id => @news.id)}]", "Edit translation")
      end
    end
  end

  describe "should render publish actions" do
    before(:each) do
      @news = model_stub(News, :translated? => false)
      locale = I18n.default_locale
      @news.stubs(:locale).returns(locale)
      I18n.stubs(:locale).returns(locale)
    end

    describe "should render when news will publish/was published" do
      it "if news published, renders when it was published" do
        date = mock
        I18n.expects(:localize).with(date, :format => :short).returns("SomeDate")
        @news.stubs(:published_at).returns(date)
        @news.stubs(:published?).returns(true)

        render "/news/_editor_actions.html.erb", :locals => {:news => @news}
        response.should have_text(/Published at SomeDate/)
      end

      it "if news will be published soon, should render appropriate message" do
        date = mock
        template.expects(:l).with(date, :format => :long).returns("SomeDateRange")
        @news.stubs(:published_at).returns(date)
        @news.stubs(:published?).returns(false)

        render "/news/_editor_actions.html.erb", :locals => {:news => @news}
        response.should have_text(/Will be published in SomeDateRange/)
      end
    end

    it "should render 'publish' link when news not published" do
      date = mock
      @news.stubs(:published_at).returns(nil)

      render "/news/_editor_actions.html.erb", :locals => {:news => @news}
      response.should have_tag("a[href=#{publish_news_item_path(:id => @news.id)}]", 'Publish')
    end

    describe "should render 'publish now' link for admin" do
      it "not published" do
        template.stubs(:admin?).returns(true)
        date = mock
        @news.stubs(:published_at).returns(nil)
        @news.stubs(:published?).returns(false)

        render "/news/_editor_actions.html.erb", :locals => {:news => @news}
        response.should have_tag("a[href=#{publish_now_news_item_path(:id => @news.id)}]", 'Publish Now')
      end
    end
  end
end
