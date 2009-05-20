require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/statistics/index" do
  before(:each) do
    assigns[:report_os] = [
      OpenStruct.new(:operating_system => "Linux", :visits => 1234),
      OpenStruct.new(:operating_system => "Windows", :visits => 1132),
      ]
    assigns[:report_browser] = [
      OpenStruct.new(:browser => "Firefox", :visits => 1234),
      OpenStruct.new(:browser => "IE", :visits => 1132),
      ]
    assigns[:report_country] = [
      OpenStruct.new(:country => "Belarus", :visits => 1234),
      OpenStruct.new(:country => "Russia", :visits => 1132),
      ]
    render 'statistics/index'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do

  end
end
