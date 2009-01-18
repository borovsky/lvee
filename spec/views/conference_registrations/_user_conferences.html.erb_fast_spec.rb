require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/conference_registrations/_user_conferences" do
  it "should render properly" do
    params[:user_id] = '1'
    conf1 = model_stub(Conference, :name => 'LVEE 2008', :start_date => Time.new, :finish_date => Time.new)
    reg = model_stub(ConferenceRegistration, :conference => conf1)
    ConferenceRegistration.expects(:find_actual_for_user).with('1').returns([reg])

    avail1 = model_stub(ConferenceRegistration, :name => 'LVEE 2009', :start_date => Time.new, :finish_date => Time.new)
    Conference.expects(:available_conferences).with([conf1]).returns([avail1])

    render 'conference_registrations/_user_conferences'
    response.should have_tag("a[href=#{user_conference_registration_path(1, reg.id)}]", conf1.name)
  end

end
