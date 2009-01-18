require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/conference_registrations/index" do
  it "should render properly" do
    params[:user_id] = '1'

    render 'conference_registrations/index'
  end
end
