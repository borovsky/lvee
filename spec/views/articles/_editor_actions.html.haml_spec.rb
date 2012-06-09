require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "articles/_editor_actions.html" do
  before(:each) do
    user = stub_model(User, :full_name=>'Vasily Pupkin')
  end

  describe "should render editor actions for article" do
    describe "if article not translated" do
      before(:each) do
        @article = stub_model(Article, :translated? => false)
      end

      it "locale default" do
        locale = I18n.default_locale
        @article.stub!(:locale).and_return(locale)
        I18n.stub!(:locale).and_return(locale)

        render "/articles/editor_actions.html.erb", :article => @article
        rendered.should have_selector("a", :href => edit_article_path(@article), :content => "Edit")
      end

      it "locale default" do
        locale = I18n.default_locale.to_s + "other"
        @article.stub!(:locale).and_return(locale)
        I18n.stub!(:locale).and_return(I18n.default_locale)

        render "/articles/editor_actions.html.erb", :article => @article
        rendered.should have_selector("a", :href => translate_article_path(@article), :content => "Translate")
      end
    end

    describe "if article translated" do
      before(:each) do
        @article = stub_model(Article, :translated? => true)
      end

      it "locale default" do
        locale = I18n.default_locale
        @article.stub!(:locale).and_return(locale)
        I18n.stub!(:locale).and_return(locale)

        render "/articles/editor_actions.html.erb", :article => @article
        rendered.should have_selector("a", :href => edit_article_path(@article), :content => "Edit translation")
      end

      it "locale default" do
        locale = I18n.default_locale.to_s + "other"
        @article.stub!(:locale).and_return(locale)
        I18n.stub!(:locale).and_return(I18n.default_locale)

        render partial: "articles/editor_actions", locals: {article: @article}
        rendered.should have_selector("a", :href => edit_article_path(@article), :content => "Edit translation")
      end
    end
  end
end
