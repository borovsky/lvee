require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/conferences/show.html.erb" do
  before(:each) do
    assigns[:conference] = @conference = model_stub(Conference)
  end

  it "should render if conference is opened without check I18n" do
    @conference.stubs(:registration_opened).returns(true)
    render "/admin/conferences/show.html.erb"
  end

  it "should render attributes in closed with check I18n" do
    @conference.stubs(:registration_opened).returns(false)
    render "/admin/conferences/show.html.erb"
  end

  it "should render if conference is opened with check requested message IDs" do
    @conference.stubs(:registration_opened).returns(true)
    template.expects(:t).with('label.conference.registration_opened').returns('opened')
    template.expects(:t).with('message.conference.status', anything).returns("")
    template.expects(:t).with('label.common.edit').returns('Edit')
    template.expects(:t).with('label.common.back').returns('Back')
    render "/admin/conferences/show.html.erb"
  end

  it "should render attributes in closed with check requested message IDs" do
    @conference.stubs(:registration_opened).returns(false)
    template.expects(:t).with('label.conference.registration_closed').returns('closed')
    template.expects(:t).with('message.conference.status', anything).returns("")
    template.expects(:t).with('label.common.edit').returns('Edit')
    template.expects(:t).with('label.common.back').returns('Back')
    render "/admin/conferences/show.html.erb"
  end

  it "should render conferenfce start date" do
    @conference.stubs(:start_date).returns(Date.parse('2008-01-01'))
    render "/admin/conferences/show.html.erb"
  end

  it "should render conferenfce finish date" do
    @conference.stubs(:finish_date).returns(Date.parse('2008-01-01'))
    render "/admin/conferences/show.html.erb"
  end
end
