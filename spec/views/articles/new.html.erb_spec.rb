require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/articles/new.html.erb" do

  before(:each) do
    assigns[:article] = model_stub(Article,
      :new_record? => true,
      :title => "value for title",
      :body => "value for body",
      :category => "value for category",
      :name => "value for subcategory",
      :locale => "value for locale"
    )
  end

  it "should render new form" do
    render "/articles/new.html.erb"

    response.should have_tag("form[action=?][method=post]", articles_path) do
      with_tag("input#article_title[name=?]", "article[title]")
      with_tag("textarea#article_body[name=?]", "article[body]")
      with_tag("input#article_category[name=?]", "article[category]")
      with_tag("input#article_name[name=?]", "article[name]")
      with_tag("input#article_locale[name=?]", "article[locale]")
    end
  end
end
