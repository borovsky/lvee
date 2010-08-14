require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/users/index.html.erb" do
  helper :application

  before(:each) do
    conf = stub(:name =>"LVEE 2009")

    assign :users, [
      stub_model(User, :full_name => "x y",
        :conference_registrations =>
        [stub(:conference => conf)],
        :active? => true),
      stub_model(User, :full_name => "a b",
        :conference_registrations =>
        [stub(:conference => conf)],
        :active? => false)]
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
