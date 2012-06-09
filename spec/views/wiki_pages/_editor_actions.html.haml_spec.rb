require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "wiki_pages/_editor_actions" do
  describe "should render editor actions for wiki_page" do
    before(:each) do
      @wiki_page = stub_model(WikiPage, :name => "name")
    end

    it "locale default" do
      locale = I18n.default_locale
      @wiki_page.stub!(:locale).and_return(locale)
      I18n.stub!(:locale).and_return(locale)

      render :partial => "/wiki_pages/editor_actions", :locals => {:wiki_page => @wiki_page}
      rendered.should have_selector("a", :href => edit_wiki_page_path(:id => @wiki_page.name),  :content => "Edit")
    end
  end
end
