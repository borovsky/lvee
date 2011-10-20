require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news/index.html.haml" do
  helper :application

  before(:each) do
    user = stub_model(User, :full_name=>'Vasily Pupkin')
    assign :news, [
      stub_model(News, :user=> user, :title => 'xyz', :lead => 'abc', :translated? => true, :published? => true),
      stub_model(News, :user=> user, :title => 'xyz', :lead => 'abc', :translated? => false, :published? => false)
    ]
  end

  describe "should render list of news" do
    describe "logged in as admin" do
      it "if locale default" do
        I18n.stub!(:locale).and_return('en')
        I18n.stub!(:default_locale).and_return('en')

        view.stub!(:current_user).and_return(stub_model(User, :role => "admin"))
        render
      end

      it "if locale not default" do
        I18n.stub!(:locale).and_return('ru')
        I18n.stub!(:defauly_locale).and_return('en')

        view.stub!(:current_user).and_return(stub_model(User, :role => "admin"))
        render
      end
    end

    describe "logged in as editor" do
      it "if locale default" do
        I18n.stub!(:locale).and_return('en')
        I18n.stub!(:default_locale).and_return('en')

        view.stub!(:current_user).and_return(stub_model(User, :role => "editor"))
        render
      end

      it "if locale not default" do
        I18n.stub!(:locale).and_return('ru')
        I18n.stub!(:defauly_locale).and_return('en')

        view.stub!(:current_user).and_return(stub_model(User, :role => "editor"))
        render
      end
    end

    describe "logged in" do
      it "if locale default" do
        I18n.stub!(:locale).and_return('en')
        I18n.stub!(:default_locale).and_return('en')

        view.stub!(:current_user).and_return(stub_model(User, :role => ""))
        render
      end

      it "if locale not default" do
        I18n.stub!(:locale).and_return('ru')
        I18n.stub!(:defauly_locale).and_return('en')

        view.stub!(:current_user).and_return(stub_model(User, :role => ""))
        render
      end
    end

    describe "logged out" do
      it "if locale default" do
        I18n.stub!(:locale).and_return('en')
        I18n.stub!(:default_locale).and_return('en')
        view.stub!(:current_user).and_return(nil)

        render
      end

      it "if locale not default" do
        I18n.stub!(:locale).and_return('ru')
        I18n.stub!(:defauly_locale).and_return('en')
        view.stub!(:current_user).and_return(nil)

        render
      end
    end
  end
end
