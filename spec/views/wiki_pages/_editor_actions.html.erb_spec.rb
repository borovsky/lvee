require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/wiki_pages/_editor_actions.html.erb" do
  before(:each) do
  end

  describe "should render editor actions for wiki_page" do
    before(:each) do
      @wiki_page = model_stub(WikiPage, :name => "name")
    end

    it "locale default" do
      locale = I18n.default_locale
      @wiki_page.stubs(:locale).returns(locale)
      I18n.stubs(:locale).returns(locale)

      render "/wiki_pages/_editor_actions.html.erb", :locals => {:wiki_page => @wiki_page}
      response.should have_tag("a[href=#{edit_wiki_page_path(:id => @wiki_page.name)}]", "Edit")
    end
  end
end
