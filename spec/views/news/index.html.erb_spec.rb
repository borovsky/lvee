require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news/index.html.erb" do
  before(:each) do
    user = model_stub(User, :full_name=>'Vasily Pupkin')
    assigns[:news] = [
      model_stub(News, :user=> user, :title => 'xyz', :lead => 'abc', :translated? => true, :published? => true),
      model_stub(News, :user=> user, :title => 'xyz', :lead => 'abc', :translated? => false, :published? => false)
    ]
  end

  describe "should render list of news" do
    describe "logged in as admin" do
      it "if locale default" do
        I18n.stubs(:locale).returns('en')
        I18n.stubs(:default_locale).returns('en')

        template.stubs(:current_user=>model_stub(User, :editor? => true, :admin? => true))
        render "/news/index.html.erb"
      end

      it "if locale not default" do
        I18n.stubs(:locale).returns('ru')
        I18n.stubs(:defauly_locale).returns('en')

        template.stubs(:current_user=>model_stub(User, :editor? => true, :admin? => true))
        render "/news/index.html.erb"
      end
    end

    describe "logged in as editor" do
      it "if locale default" do
        I18n.stubs(:locale).returns('en')
        I18n.stubs(:default_locale).returns('en')

        template.stubs(:current_user=>model_stub(User, :editor? => true, :admin? => false))
        render "/news/index.html.erb"
      end

      it "if locale not default" do
        I18n.stubs(:locale).returns('ru')
        I18n.stubs(:defauly_locale).returns('en')

        template.stubs(:current_user=>model_stub(User, :editor? => true, :admin? => false))
        render "/news/index.html.erb"
      end
    end

    describe "logged in" do
      it "if locale default" do
        I18n.stubs(:locale).returns('en')
        I18n.stubs(:default_locale).returns('en')

        template.stubs(:current_user=>model_stub(User, :editor? => false, :admin? => false))
        render "/news/index.html.erb"
      end

      it "if locale not default" do
        I18n.stubs(:locale).returns('ru')
        I18n.stubs(:defauly_locale).returns('en')

        template.stubs(:current_user=>model_stub(User, :editor? => false, :admin? => false))
        render "/news/index.html.erb"
      end
    end

    describe "logged out" do
      it "if locale default" do
        I18n.stubs(:locale).returns('en')
        I18n.stubs(:default_locale).returns('en')

        render "/news/index.html.erb"
      end

      it "if locale not default" do
        I18n.stubs(:locale).returns('ru')
        I18n.stubs(:defauly_locale).returns('en')

        render "/news/index.html.erb"
      end
    end
  end
end
