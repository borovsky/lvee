require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/articles/new.html.erb" do

  before(:each) do
    assign :article, stub_model(Article,
      :new_record? => true,
      :title => "value for title",
      :body => "value for body",
      :category => "value for category",
      :name => "value for subcategory",
      :locale => "value for locale"
    )
  end

  it "should render new form" do
    render

    rendered.should have_selector("form[method=post]", :action => articles_path(:lang => "en")) do |n|
      n.should have_selector("input#article_title", :name => "article[title]")
      n.should have_selector("textarea#article_body", :name => "article[body]")
      n.should have_selector("input#article_category", :name => "article[category]")
      n.should have_selector("input#article_name", :name => "article[name]")
      n.should have_selector("input#article_locale", :name => "article[locale]")
    end
  end
end
