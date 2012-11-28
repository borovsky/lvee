require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "admin/users/index.html.haml" do
  helper :application

  before(:each) do
    conf = Conference.new(:name =>"LVEE 2009")
    conf.save(:validate => false)
    user1 = User.new(:first_name => "x", :first_name => "y")
    user1.save(:validate => false)
    user1.conference_registrations << ConferenceRegistration.new(:conference_id => conf.id)
    user2 = User.new(:first_name => "a", :last_name => "b")
    user2.save(:validate => false)
    user2.conference_registrations << ConferenceRegistration.new(:conference_id => conf.id)

    assign :users, [user1, user2]
    assign :conferences, [conf]
    assign :statistics, stub(
      :list => {"LVEE 2009" =>
        stub(:statistics => {:total_men =>20, :approved_men => 10,
            :total_registrations =>10, :approved_registrations => 5 })
      })
  end

  it "should render attributes in <p>" do
    render
  end
end
