require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/articles/_editor_actions.html.erb" do
  before(:each) do
    user = model_stub(User, :full_name=>'Vasily Pupkin')
  end

  describe "should render editor actions for article" do
    describe "if article not translated" do
      before(:each) do
        @article = model_stub(Article, :translated? => false)
      end

      it "locale default" do
        locale = I18n.default_locale
        @article.stubs(:locale).returns(locale)
        I18n.stubs(:locale).returns(locale)

        render "/articles/_editor_actions.html.erb", :locals => {:article => @article}
        response.should have_tag("a[href=#{edit_article_path(:id => @article.id)}]", "Edit")
      end

      it "locale default" do
        locale = I18n.default_locale + "other"
        @article.stubs(:locale).returns(locale)
        I18n.stubs(:locale).returns(I18n.default_locale)

        render "/articles/_editor_actions.html.erb", :locals => {:article => @article}
        response.should have_tag("a[href=#{translate_article_path(:id => @article.id)}]", "Translate")
      end
    end

    describe "if article translated" do
      before(:each) do
        @article = model_stub(Article, :translated? => true)
      end

      it "locale default" do
        locale = I18n.default_locale
        @article.stubs(:locale).returns(locale)
        I18n.stubs(:locale).returns(locale)

        render "/articles/_editor_actions.html.erb", :locals => {:article => @article}
        response.should have_tag("a[href=#{edit_article_path(:id => @article.id)}]", "Edit translation")
      end

      it "locale default" do
        locale = I18n.default_locale + "other"
        @article.stubs(:locale).returns(locale)
        I18n.stubs(:locale).returns(I18n.default_locale)

        render "/articles/_editor_actions.html.erb", :locals => {:article => @article}
        response.should have_tag("a[href=#{edit_article_path(:id => @article.id)}]", "Edit translation")
      end
    end
  end
end
