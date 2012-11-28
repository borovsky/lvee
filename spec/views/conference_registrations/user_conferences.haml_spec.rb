require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "conference_registrations/_user_conferences.haml" do
  before(:each) do
    @user = FactoryGirl.create :user
    view.stub!(:current_user).and_return(@user)
    @future_conf = FactoryGirl.create :conference, :in_future
    @old_conf = FactoryGirl.create :conference, :in_past
  end

  it "should render if no info" do
    assign :available_conferences, []
    assign :current_registrations, []
    assign :participated_conferences, []

    render
  end

  it "should render link for register to conference" do
    assign :available_conferences, [@future_conf]
    assign :current_registrations, []
    assign :participated_conferences, []

    render

    to = new_user_conference_registration_path(user_id: @user, conference_id: @future_conf)
    render.should have_selector("p.register > a.big-button[href='#{to}']")
  end

  it "should render cancelled conference" do
    @cr_cancelled = FactoryGirl.create(:conference_registration, :cancelled,
                                       conference: @future_conf, user: @user)
    assign :available_conferences, []
    assign :current_registrations, [@cr_cancelled]
    assign :participated_conferences, []

    render

    render.should have_selector("p.cancelled", content: @future_conf.name)
  end

  it "should render link to edit new conference registration" do
    @cr_new = FactoryGirl.create(:conference_registration, :new,
                                 conference: @future_conf, user: @user)
    assign :available_conferences, []
    assign :current_registrations, [@cr_new]
    assign :participated_conferences, []

    render

    to = edit_user_conference_registration_path(user_id: @user, id: @cr_new)
    render.should have_selector("p.edit>a.big-button[href='#{to}']")
  end

  it "should render link to edit approved conference registration" do
    @cr_approved = FactoryGirl.create(:conference_registration, :approved,
                                      conference: @future_conf, user: @user)
    assign :available_conferences, []
    assign :current_registrations, [@cr_approved]
    assign :participated_conferences, []

    render

    to = edit_user_conference_registration_path(user_id: @user, id: @cr_approved)
    render.should have_selector("p.approved_edit>a.big-button[href='#{to}']")
  end

  it "should render link to cancel conference registration" do
    @cr_new = FactoryGirl.create(:conference_registration, :new,
                                 conference: @future_conf, user: @user)
    assign :available_conferences, []
    assign :current_registrations, [@cr_new]
    assign :participated_conferences, []

    render

    to = cancel_user_conference_registration_path(user_id: @user, id: @cr_new)
    render.should have_selector("p>a[data-confirm][href='#{to}']")
  end

  it "should render list of participated conferences" do
    @cr_approved = FactoryGirl.create(:conference_registration, :approved,
                                 conference: @old_conf, user: @user)
    assign :available_conferences, []
    assign :current_registrations, []
    assign :participated_conferences, [@cr_approved]

    render

    render.should have_selector("ul.participated>li", content: @old_conf.name)
  end

end
