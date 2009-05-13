require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/languages/show.html.erb" do
  before(:each) do
    conf = stub(:name =>"LVEE 2009")

    assigns[:users] = [
      model_stub(User, :full_name => "x y",
        :conference_registrations =>
        [stub(:conference => conf)]
        ),
      model_stub(User, :full_name => "a b",
        :conference_registrations =>
        [stub(:conference => conf)]
        )]
    assigns[:conferences] = [conf]
    assigns[:statistics] = stub(
      :list => {"LVEE 2009" =>
        stub(:total_men =>20, :approved_men => 10,
          :total_registrations =>10, :approved_registrations => 5 )
      }
      )
  end

  it "should render attributes in <p>" do
    render "/admin/users/index.html.erb"
  end
end
