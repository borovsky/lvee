# Controller for work with users: create(signup), update, delete, activate

class UsersController < ApplicationController
  before_filter :login_required, :only => [:current]
  before_filter :scaffold_action, :set_common_columns_info, :only => [:edit, :update, :new, :create]
  before_filter(:current_user_only, :unless => :admin?,
    :except => [:restore, :activate, :current,:new, :create])


  USER_EDITABLE_COLUMNS = [:password, :password_confirmation, :email, :first_name, :last_name, :country, :city,
  :occupation, :projects, :subscribed]
  ONLY_CREATE_COLUMNS = [:login]
  COLUMNS = ONLY_CREATE_COLUMNS + USER_EDITABLE_COLUMNS
  PRIORITY_COUNTRIES = ['Belarus', 'Ukraine', 'Russia']

  LOCALIZATION_LABEL_PREFIX = "label.user."
  LOCALIZATION_DESCRIPTION_PREFIX = "description.user."

  active_scaffold :users do
    cls = UsersController
    self.actions = [:create, :update]
    self.columns = cls::COLUMNS
    self.create.columns = cls::COLUMNS
    self.update.columns = cls::USER_EDITABLE_COLUMNS

    self.columns[:subscribed].form_ui = :checkbox
    self.columns[:password].form_ui = :password
    self.columns[:password_confirmation].form_ui = :password
    self.columns[:country].form_ui = :country
    self.columns[:country].options[:priority] = cls::PRIORITY_COUNTRIES
    User::REQUIRED_FIELDS.each{|i| self.columns[i].required = true }
  end

  def list
    redirect_to  user_path(:id => current_user.id)
  end

  def index
    redirect_to  user_path(:id => current_user.id)
  end

  def current
    redirect_to user_path(:id => current_user.id)
  end

  def restore
    if params[:email]
      user = User.find_by_email(params[:email])
      if user
        if user.active?
          password = random_pronouncable_password

          user.password = password
          user.password_confirmation = password
          user.save
          UserMailer.deliver_password_restore(user, request.remote_ip)
        else
          UserMailer.deliver_activation_restore(user)
        end
        flash[:notice] = t('message.user.password_restore_note')
      else
        flash[:error] = t('message.user.not_found_by_email')
      end
    end
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
    params[:user] ||= {}
    user_params = params[:user].slice(:avator, :avator_temp)

    if @user.update_attributes(user_params)
      flash[:notice] = t("message.user.avator_updated")
      redirect_to user_path(:id => @user)
    else
      flash[:error] = t("message.user.incorrect_image")
      logger.error @user.errors.inspect
      redirect_to user_path(:id => @user)
    end
  end

  protected
  def current_user_only
    login_required
    return if performed?
    render :text => t('message.common.access_denied'), :status=>403 unless params[:id].to_s == current_user.id.to_s
  end

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

  def random_pronouncable_password(size = 4)
    c = %w(b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr)
    v = %w(a e i o u y)
    f, r = true, ''
    (size * 2).times do
      r << (f ? c[rand * c.size] : v[rand * v.size])
      f = !f
    end
    r
  end
end
