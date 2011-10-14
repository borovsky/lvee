require 'spec_helper'

describe "thesises/index.html.haml" do
  before(:each) do
    @admin = stub_model(User, :role => "admin")

    user = stub_model(User, :first_name => "Test1", :last_name => "Test2")
    user2 = stub_model(User, :first_name => "Test3", :last_name => "Test4")
    assign(:thesises, [
      stub_model(Thesis,
        :conference_registration => stub_model(ConferenceRegistration, :user => user),
        :title => "Title",
        :body => "MyText"
      ),
      stub_model(Thesis,
        :conference_registration => stub_model(ConferenceRegistration, :user => user2),
        :title => "Title",
        :body => "MyText"
      )
    ])
  end

  it "renders a list of thesises" do
    login_as @admin
    render
  end
end
