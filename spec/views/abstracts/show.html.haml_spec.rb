require 'spec_helper'

describe "abstracts/show.html.haml" do
  before(:each) do
    @abstract = assign(:abstract, stub_model(Abstract,
      :conference_registration_id => 1,
      :title => "Title",
      :body => "MyText"
    ))
    @comments = assign(:comments, [
      ])
    @new_comment = assign(:new_comment, AbstractComment.new)
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
