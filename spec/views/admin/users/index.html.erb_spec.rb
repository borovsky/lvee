require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/users/index.html.erb" do
  helper :application

  before(:each) do
    conf = Conference.new(:name =>"LVEE 2009")
    conf.save(:validate => false)
    user1 = User.new(:name => "x", :surname => "y")
    user1.save(:validate => false)
    user1.conference_registrations << ConferenceRegistration.new(:conference => conf)
    user2 = User.new(:name => "a", :surname => "b")
    user2.save(:validate => false)
    user2.conference_registrations << ConferenceRegistration.new(:conference => conf)

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
