require 'spec_helper'

describe "abstracts/edit.html.haml" do
  before(:each) do
    @user = stub_model(User, :first_name => "Test1", :last_name => "Test2")

    @abstract = assign(:abstract, stub_model(Abstract,
      :conference => stub_model(Conference, :name => "test"),
      :title => "MyString",
      :body => "MyText"
    ))
  end

  it "renders the new abstract form" do
    login_as @user
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => abstract_path(@abstract), :method => "post" do
      assert_select "input#abstract_title", :name => "abstract[title]"
      assert_select "input#abstract_authors", :name => "abstract[authors]"
      assert_select "textarea#abstract_abstract", :name => "abstract[abstract]"
      assert_select "textarea#abstract_body", :name => "abstract[body]"
      assert_select "input#abstract_ready_for_review", :name => "abstract[ready_for_review]", :type => "checkbox"
    end
  end
end
