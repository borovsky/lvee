require 'spec_helper'

describe "thesises/edit.html.haml" do
  before(:each) do
    @user = stub_model(User, :first_name => "Test1", :last_name => "Test2")

    @thesis = assign(:thesis, stub_model(Thesis,
      :conference_registration_id => 1,
      :title => "MyString",
      :body => "MyText"
    ))
  end

  it "renders the new thesis form" do
    login_as @user
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => thesis_path(@thesis), :method => "post" do
      assert_select "input#thesis_title", :name => "thesis[title]"
      assert_select "input#thesis_authors", :name => "thesis[authors]"
      assert_select "textarea#thesis_abstract", :name => "thesis[abstract]"
      assert_select "textarea#thesis_body", :name => "thesis[body]"
      assert_select "input#thesis_ready_for_review", :name => "thesis[ready_for_review]", :type => "checkbox"
    end
  end
end
