require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news/_editor_actions.html.haml" do
  before(:each) do
    user = FactoryGirl.create :user
  end

  describe "should render editor actions for news" do
    describe "if news not translated" do
      before(:each) do
        @news = stub_model(News, :translated? => false)
      end

      it "locale default" do
        locale = I18n.default_locale
        @news.stub!(:locale).and_return(locale)
        I18n.stub!(:locale).and_return(locale)
        view.stub!(:admin?).and_return(true)

        render partial: "/news/editor_actions", locals: {news: @news}
        rendered.should have_selector("a", href: edit_news_item_path(@news), content: "Edit")
      end

      it "locale default" do
        locale = I18n.default_locale.to_s + "other"
        @news.stub!(:locale).and_return(locale)
        I18n.stub!(:locale).and_return(I18n.default_locale)
        view.stub!(:admin?).and_return(true)

        render partial: "/news/editor_actions", locals: {news: @news}
        rendered.should have_selector("a", href: translate_news_path(parent_id: @news.id,
                                                                     locale: I18n.default_locale),
                                      content: "Translate")
      end
    end

    describe "if news translated" do
      before(:each) do
        @news = stub_model(News, :translated? => true)
      end

      it "locale default" do
        locale = I18n.default_locale
        @news.stub!(:locale).and_return(locale)
        I18n.stub!(:locale).and_return(locale)
        view.stub!(:admin?).and_return(true)

        render partial: "/news/editor_actions", locals: {news: @news}
        rendered.should have_selector("a", href: edit_news_item_path(@news), content: "Edit translation")
      end

      it "locale default" do
        locale = I18n.default_locale.to_s + "other"
        @news.stub!(:locale).and_return(locale)
        I18n.stub!(:locale).and_return(I18n.default_locale)
        view.stub!(:admin?).and_return(true)

        render partial: "/news/editor_actions", locals: {news: @news}
        rendered.should have_selector("a", href: edit_news_item_path(@news), content: "Edit translation")
      end
    end
  end

  describe "should render publish actions" do
    before(:each) do
      @news = stub_model(News, translated?: false)
      locale = I18n.default_locale
      @news.stub!(:locale).and_return(locale)
      I18n.stub!(:locale).and_return(locale)
    end

    describe "should render when news will publish/was published" do
      it "if news published, renders when it was published" do
        date = mock
        I18n.should_receive(:localize).with(date, format: :short).and_return("SomeDate")
        @news.stub!(:published_at).and_return(date)
        @news.stub!(:published?).and_return(true)
        view.stub!(:admin?).and_return(true)

        render partial: "/news/editor_actions", locals: {news: @news}
        rendered.should match(/Published at SomeDate/)
      end

      it "if news will be published soon, should render appropriate message" do
        date = mock
        view.should_receive(:l).with(date, format: :long).and_return("SomeDateRange")
        view.stub!(:admin?).and_return(true)
        @news.stub!(:published_at).and_return(date)
        @news.stub!(:published?).and_return(false)

        render partial: "/news/editor_actions", locals: {news: @news}
        rendered.should match(/Will be published in SomeDateRange/)
      end
    end

    it "should render 'publish' link when news not published" do
      date = mock
      @news.stub!(:published_at).and_return(nil)
      view.stub!(:admin?).and_return(true)

      render partial: "/news/editor_actions", locals: {news: @news}
      rendered.should have_selector("a", href: publish_news_item_path(@news), content: 'Publish')
    end

    describe "should render 'publish now' link for admin" do
      it "not published" do
        view.stub!(:admin?).and_return(true)
        date = mock
        @news.stub!(:published_at).and_return(nil)
        @news.stub!(:published?).and_return(false)

        render partial: "/news/editor_actions", :locals => {:news => @news}
        rendered.should have_selector("a", href: publish_now_news_item_path(@news), content: 'Publish Now')
      end
    end
  end
end
