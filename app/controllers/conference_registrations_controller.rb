class ConferenceRegistrationsController < ApplicationController
  before_filter :current_user_only

  def index

  end

  def new
    conference = Conference.find(params[:conference_id])
    @registration = ConferenceRegistration.new(:conference => conference)
    return redirect_to(:action => 'index') unless conference.registration_opened
  end

  def create
    @registration = ConferenceRegistration.new(params[:conference_registration])
    @registration.status_name = 'New'
    @registration.user_id = current_user.id
    conference_id = @registration.conference_id
    return redirect_to(:action => 'index') unless conference_id && Conference.find(conference_id).registration_opened
    if @registration.save
      redirect_to user_conference_registration_path(:user_id => @registration.user_id, :id => @registration.id)
    else
      render :action => 'new'
    end
  end

  def edit
    @registration = ConferenceRegistration.find_by_id_and_user_id(params[:id], params[:user_id])
    render :text => t('message.common.access_denied'), :status => 403 unless @registration
  end

  def update
    @registration = ConferenceRegistration.find_by_id_and_user_id(params[:id], params[:user_id])
    return render(:text => t('message.common.access_denied'), :status => 403) unless @registration
    if @registration.update_attributes(params[:conference_registration])
      redirect_to user_conference_registration_path(:user_id => params[:user_id], :id => params[:id])
    else
      render :action => 'edit', :id => params[:id]
    end
  end

  def show
    @registration = ConferenceRegistration.find_by_id_and_user_id(params[:id], params[:user_id])
    return render(:text => t('message.common.access_denied'), :status => 403) unless @registration
  end

  protected
  def current_user_only
    render :text => t('message.common.access_denied'), :status=>403 unless params[:user_id].to_s == current_user.id.to_s
  end

  def default_url_options(options={})
    opts = current_user ? {:user_id => current_user.id} : {}
    super(options).merge(opts)
  end
end
