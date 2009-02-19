require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/articles/edit.html.erb" do
  include ArticlesHelper

  before(:each) do
    assigns[:article] = @article = model_stub(Article,
      :new_record? => false,
      :title => "value for title",
      :body => "value for body",
      :category => "value for category",
      :name => "value for subcategory",
      :in_menu => false,
      :locale => "value for locale"
    )
  end

  it "should render edit form" do
    render "/articles/edit.html.erb"

    response.should have_tag("form[action=#{article_path(:id => @article.id)}][method=post]") do
      with_tag('input#article_title[name=?]', "article[title]")
      with_tag('textarea#article_body[name=?]', "article[body]")
      with_tag('input#article_category[name=?]', "article[category]")
      with_tag('input#article_name[name=?]', "article[name]")
      with_tag('input#article_in_menu[name=?]', "article[in_menu]")
    end
  end
end
