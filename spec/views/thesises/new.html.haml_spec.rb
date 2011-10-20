require 'spec_helper'

describe "thesises/new.html.haml" do
  before(:each) do
    @thesis = assign(:thesis, Thesis.new)
    @user = stub_model(User)
  end

  it "renders the edit thesis form many conferences" do
    login_as @user
    @confs = assign(:actual_conferences, [stub_model(Conference, :name => "tst"),
      stub_model(Conference, :name => "tst2")])
    render

    assert_select "form", :action => thesises_path, :method => "post" do
      assert_select "select#thesis_conference_id", :name => "thesis[conference_registration_id]"
      assert_select "input#thesis_title", :name => "thesis[title]"
      assert_select "input#thesis_authors", :name => "thesis[authors]"
      assert_select "textarea#thesis_abstract", :name => "thesis[abstract]"
      assert_select "textarea#thesis_body", :name => "thesis[body]"
    end
  end

  it "renders the edit thesis form one conference" do
    login_as @user
    @confs = assign(:actual_conferences, [stub_model(Conference, :name => "tst")])
    render

    assert_select "form", :action => thesises_path, :method => "post" do
      assert_select "input#thesis_conference_id", :name => "thesis[conference_registration_id]"
      assert_select "input#thesis_title", :name => "thesis[title]"
      assert_select "input#thesis_authors", :name => "thesis[authors]"
      assert_select "textarea#thesis_abstract", :name => "thesis[abstract]"
      assert_select "textarea#thesis_body", :name => "thesis[body]"
    end
  end
end
