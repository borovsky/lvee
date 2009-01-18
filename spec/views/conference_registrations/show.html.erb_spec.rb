require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/conference_registrations/show" do
  it "should tell you where to find the file" do
    conf1 = model_stub(Conference, :name => 'LVEE 2008', :start_date => Time.new, :finish_date => Time.new, :id => 42)
    reg = model_stub(ConferenceRegistration, :conference => conf1, :id =>42)
    assigns[:registration] = reg
    params[:user_id] = '1'

    render 'conference_registrations/show'
  end
end
