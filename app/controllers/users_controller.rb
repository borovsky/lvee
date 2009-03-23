# Controller for work with users: create(signup), update, delete, activate

class UsersController < ApplicationController
  before_filter :login_required, :only => [:show, :index, :edit, :update, :current]
  before_filter :scaffold_action, :set_common_columns_info, :only => [:edit, :update, :new, :create]

  USER_EDITABLE_COLUMNS = [:password, :password_confirmation, :email, :first_name, :last_name, :country, :city,
  :occupation, :projects, :subscribed]
  ONLY_CREATE_COLUMNS = [:login]
  COLUMNS = ONLY_CREATE_COLUMNS + USER_EDITABLE_COLUMNS
  PRIORITY_COUNTRIES = ['Belarus', 'Ukraine', 'Russia']

  LOCALIZATION_LABEL_PREFIX = "label.user."
  LOCALIZATION_DESCRIPTION_PREFIX = "description.user."

  active_scaffold :users do |config|
    config.actions = [:create, :update]
    config.columns = COLUMNS
    config.create.columns = COLUMNS
    config.update.columns = USER_EDITABLE_COLUMNS

    config.columns[:subscribed].form_ui = :checkbox
    config.columns[:password].form_ui = :password
    config.columns[:password_confirmation].form_ui = :password
    config.columns[:country].form_ui = :country
    config.columns[:country].options[:priority] = PRIORITY_COUNTRIES
    User::REQUIRED_FIELDS.each{|i| config.columns[i].required = true }
  end

  def list
    redirect_to user_path(:id => current_user.id)
  end

  def current
    redirect_to user_path(:id => current_user.id)
  end

  def activate
    user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if user && !user.active?
      user.activate
      self.current_user = user
      flash[:notice] = t('message.user.activated')
      redirect_to user_path(:id=>current_user)
    else
      redirect_back_or_default('/')
    end
  end

  def show
    user_have_access = (current_user.id.to_s == params[:id]) || current_user.admin?
    return render(:text=>t('message.common.access_denied'), :status => 403) unless user_have_access
    @user = User.find params[:id]
  end

  def upload_avator
    @user = User.find(params[:id])
    user_params = params[:user].slice(:avator, :avator_temp)

    if @user.update_attributes(user_params)
      flash[:notice] = t("message.user.avator_updated")
      redirect_to user_path(:id => @user)
    else
      flash[:error] = t("message.user.incorrect_image")
      redirect_to user_path(:id => @user)
    end
  end

  protected
  def after_create_save(record)
    UserMailer.deliver_signup_notification(record)
    self.current_user = record
    redirect_to user_path(:id => current_user.id, :lang => params[:lang])
  end


  def after_update_save(record)
    redirect_to user_path(:id=>record)
  end

  def set_common_columns_info
    config = active_scaffold_config
    [:password, :password_confirmation].each do |i|
      config.columns[i].required = ['new', 'create'].include?(action_name)
    end
    config.label = t('label.user.register')
    COLUMNS.each do |c|
      config.columns[c].label = t(LOCALIZATION_LABEL_PREFIX + c.to_s)
      config.columns[c].description = t(LOCALIZATION_DESCRIPTION_PREFIX + c.to_s)
    end
    config.create.label = t('label.user.register')
    config.update.label = t('label.user.title', :full_name => current_user.full_name, :login => current_user.login) if current_user
  end
end
