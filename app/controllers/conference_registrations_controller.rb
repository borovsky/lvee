class ConferenceRegistrationsController < ApplicationController
  before_filter :current_user_only, :set_common_columns_info, :except => :user_list
  before_filter :login_required, :only => :user_list

  EDITABLE_COLUMNS = [:days, :meeting, :phone, :floor, :transport_to, :transport_from,
                      :residence, :food, :tshirt]
  STATIC_COLUMNS = [:proposition, :quantity]
  HIDDEN_COLUMNS = [:conference_id]
  COLUMNS = STATIC_COLUMNS + EDITABLE_COLUMNS

  LOCALIZATION_LABEL_PREFIX = "label.conference_registration."
  LOCALIZATION_DESCRIPTION_PREFIX = "description.conference_registration."

  FIRST_STEP_COLUMNS = [:proposition, :quantity]

  @@default_column_ui ||= {}
  active_scaffold :conference_registration do |conf|
    cls = ConferenceRegistrationsController
    conf.actions = [:create, :update, :show]
    conf.columns = cls::COLUMNS
    conf.create.columns = cls::FIRST_STEP_COLUMNS + cls::HIDDEN_COLUMNS

    conf.update.columns = cls::STATIC_COLUMNS + cls::EDITABLE_COLUMNS
    cls::STATIC_COLUMNS.each do |c|
      conf.columns[c].form_ui = :static if self.update.columns[c]
    end
  end

  def index
    redirect_to user_path(:id => current_user.id)
  end

  def list
    redirect_to user_path(:id => current_user.id)
  end

  def user_list
    @conference = Conference.find_by_name!(params[:id])
    @registrations = ConferenceRegistration.participants(@conference)
  end

  def badges
    @conference_registration = ConferenceRegistration.find(params[:id])
    @conference = @conference_registration.conference
    if params[:badges]
      @conference_registration.badges.clear
      params[:badges].each  do|b|
        @conference_registration.badges.create!(b)
      end
      redirect_to user_path(:id => params[:user_id])
    else
      @badges = @conference_registration.badges
    end
  end

  def cancel
    @conference_registration = ConferenceRegistration.find(params[:id])
    @conference_registration.cancel!
    redirect_to user_path(:id => current_user.id)
  end

  protected
  def current_user_only
    login_required
    return if performed?
    return if admin?
    render :text => t('message.common.access_denied'), :status=>403 unless params[:user_id].to_s == current_user.id.to_s
    ConferenceRegistration.find_by_id_and_user_id!(params[:id], params[:user_id]) if params[:id]
  end

  def default_url_options(options={})
    base = super(options)
    opts = current_user ? {:user_id => current_user.id} : {}
    if options[:controller] == 'conference_registration'
      base.merge(opts)
    else
      base
    end
  end

  def do_new
    super
    @record.user_id = params[:user_id]
    @record.conference_id = params[:conference_id]
    @record.quantity ||= 1
    active_scaffold_config.create.label = t('label.conference_registration.title', :conference =>Conference.find(params[:conference_id]).name)
    active_scaffold_config.columns[:proposition].form_ui = :textarea
    active_scaffold_config.columns[:conference_id].form_ui = :hidden
  end

  def do_edit
    super

    @record.days = (@record.days || "").split(',')
    @record.tshirt = (@record.tshirt || "").split(',')

    active_scaffold_config.update.label = t('label.conference_registration.title', :conference =>Conference.find(@record.conference_id).name)

    active_scaffold_config.columns[:proposition].form_ui = :textarea
    if @record.status_name == APPROVED_STATUS
      active_scaffold_config.update.columns = COLUMNS
      STATIC_COLUMNS.each { |c| active_scaffold_config.columns[c].form_ui = :static}
    else
      active_scaffold_config.update.columns = FIRST_STEP_COLUMNS
    end

    #hack!
    #active_scaffold_config._load_action_columns
  end

  def set_common_columns_info
    unless @@default_column_ui.size
      config.columns.each do |c|
        @@default_column_ui[c.name.to_sym] = c.form_ui
      end
    end

    COLUMNS.each do |c|
      active_scaffold_config.columns[c].label = t(LOCALIZATION_LABEL_PREFIX + c.to_s)
      active_scaffold_config.columns[c].description = textilize(t(LOCALIZATION_DESCRIPTION_PREFIX + c.to_s)).html_safe
      active_scaffold_config.columns[c].form_ui = @@default_column_ui[c]
    end
  end

  def before_create_save(record)
    record.user_id = params[:user_id]
    @record.status_name = NEW_STATUS
  end

  def before_update_save(record)
    @record.days = @record.days.delete_if(&:blank?).join(',') if @record.days.kind_of? Array
    @record.tshirt = @record.tshirt.join(',') if @record.tshirt.kind_of? Array
  end
end
