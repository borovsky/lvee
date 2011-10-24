require 'spec_helper'

describe "abstracts/new.html.haml" do
  before(:each) do
    @abstract = assign(:abstract, Abstract.new)
    @user = stub_model(User)
  end

  it "renders the edit abstract form many conferences" do
    login_as @user
    @confs = assign(:actual_conferences, [stub_model(Conference, :name => "tst"),
      stub_model(Conference, :name => "tst2")])
    render

    assert_select "form", :action => abstracts_path, :method => "post" do
      assert_select "select#abstract_conference_id", :name => "abstract[conference_registration_id]"
      assert_select "input#abstract_title", :name => "abstract[title]"
      assert_select "input#abstract_authors", :name => "abstract[authors]"
      assert_select "textarea#abstract_summary", :name => "abstract[summary]"
      assert_select "textarea#abstract_body", :name => "abstract[body]"
      assert_select "input#abstract_license", :name => "abstract[license]"
    end
  end

  it "renders the edit abstract form one conference" do
    login_as @user
    @confs = assign(:actual_conferences, [stub_model(Conference, :name => "tst")])
    render

    assert_select "form", :action => abstracts_path, :method => "post" do
      assert_select "input#abstract_conference_id", :name => "abstract[conference_registration_id]"
      assert_select "input#abstract_title", :name => "abstract[title]"
      assert_select "input#abstract_authors", :name => "abstract[authors]"
      assert_select "textarea#abstract_summary", :name => "abstract[summary]"
      assert_select "textarea#abstract_body", :name => "abstract[body]"
      assert_select "input#abstract_license", :name => "abstract[license]"
    end
  end
end
