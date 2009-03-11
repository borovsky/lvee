class ConferenceRegistrationsController < ApplicationController
  before_filter :current_user_only, :scaffold_action, :set_common_columns_info

  EDITABLE_COLUMNS = [:days, :food, :meeting, :phone, :transport, :tshirt]
  STATIC_COLUMNS = [:proposition, :quantity]
  HIDDEN_COLUMNS = [:conference_id]
  COLUMNS = STATIC_COLUMNS + EDITABLE_COLUMNS

  LOCALIZATION_LABEL_PREFIX = "label.conference_registration."
  LOCALIZATION_DESCRIPTION_PREFIX = "description.conference_registration."

  FIRST_STEP_COLUMNS = [:proposition, :quantity]

  @@default_column_ui ||= {}
  active_scaffold :conference_registrations do |config|
    config.label = "Conference Registration"
    config.actions = [:create, :update, :show]
    config.columns = COLUMNS
    config.create.columns = FIRST_STEP_COLUMNS + HIDDEN_COLUMNS

    config.update.columns = STATIC_COLUMNS + EDITABLE_COLUMNS
    STATIC_COLUMNS.each do |c|
      config.columns[c].form_ui = :static if config.update.columns[c]
    end
  end

  def index
    redirect_to user_path(:id => current_user.id)
  end

  def list
    redirect_to user_path(:id => current_user.id)
  end

  protected
  def current_user_only
    render :text => t('message.common.access_denied'), :status=>403 unless params[:user_id].to_s == current_user.id.to_s
  end

  def default_url_options(options={})
    opts = current_user ? {:user_id => current_user.id} : {}
    super(options).merge(opts)
  end

  def do_new
    super
    @record.user_id = params[:user_id]
    @record.conference_id = params[:conference_id]
    @record.quantity ||= 1
    active_scaffold_config.create.label = t('label.conference_registration.title', :conference =>Conference.find(params[:conference_id]).name)

  end

  def do_edit
    super

    @record.days = (@record.days || "").split(',')
    @record.tshirt = (@record.tshirt || "").split(',')

    active_scaffold_config.update.label = t('label.conference_registration.title', :conference =>Conference.find(@record.conference_id).name)

    if @record.status_name == APPROVED_STATUS
      active_scaffold_config.update.columns = COLUMNS
      STATIC_COLUMNS.each { |c| active_scaffold_config.columns[c].form_ui = :static}
    else
      active_scaffold_config.update.columns = FIRST_STEP_COLUMNS
    end

    #hack!
    active_scaffold_config._load_action_columns
  end

  def set_common_columns_info
    unless @@default_column_ui.size
      config.columns.each do |c|
        @@default_column_ui[c.name.to_sym] = c.form_ui
      end
    end

    COLUMNS.each do |c|
      active_scaffold_config.columns[c].label = t(LOCALIZATION_LABEL_PREFIX + c.to_s)
      active_scaffold_config.columns[c].description = t(LOCALIZATION_DESCRIPTION_PREFIX + c.to_s)
      active_scaffold_config.columns[c].form_ui = @@default_column_ui[c]
    end
  end

  def before_create_save(record)
    record.user = current_user
    @record.status_name = NEW_STATUS
  end

  def before_update_save(record)
    @record.days = @record.days.join(',') if @record.days.kind_of? Array
    @record.tshirt = @record.tshirt.join(',') if @record.tshirt.kind_of? Array
    @record.status_name = NEW_STATUS
  end


end
