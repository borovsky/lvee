require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news/new.html.erb" do
  before(:each) do
    assign :news, stub_model(News,
      :new_record? => true,
      :errors => []
    )
  end

  it "should render new form" do
    view.stub!(:current_user=>stub_model(User, :site_editor? => true))
    render

    rendered.should have_selector("form[method=post]", :action => news_item_index_path(:lang => "en"))
  end
end
