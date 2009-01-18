require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news/edit.html.erb" do
  before(:each) do
    @news = model_stub(News,
      :new_record? => false,
      :errors => [],
      :id => 1234
      )
    assigns[:news] = @news
  end

  it "should render edit form" do
    render "/news/edit.html.erb"

    response.should have_tag("form[action=#{news_item_path(@news)}][method=post]") do
    end
  end
end
