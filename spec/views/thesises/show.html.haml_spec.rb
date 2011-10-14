require 'spec_helper'

describe "thesises/show.html.haml" do
  before(:each) do
    @thesis = assign(:thesis, stub_model(Thesis,
      :conference_registration_id => 1,
      :title => "Title",
      :body => "MyText"
    ))
    @comments = assign(:comments, [
      ])
    @new_comment = assign(:new_comment, ThesisComment.new)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
