# Controller for work with users: create(signup), update, delete, activate

class UsersController < ApplicationController
  before_filter :login_required, :only => [:current]
  before_filter :set_common_columns_info, :only => [:edit, :update, :new, :create]
  before_filter(:current_user_only, :unless => :admin?,
    :except => [:restore, :activate, :current, :new, :create])

  USER_EDITABLE_COLUMNS = [:password, :password_confirmation, :email, :first_name, :last_name, :country, :city,
    :occupation, :projects, :subscribed, :subscribed_talks]
  ONLY_CREATE_COLUMNS = [:login]
  COLUMNS = ONLY_CREATE_COLUMNS + USER_EDITABLE_COLUMNS
  PRIORITY_COUNTRIES = ['Belarus', 'Ukraine', 'Russia']

  LOCALIZATION_LABEL_PREFIX = "label.user."
  LOCALIZATION_DESCRIPTION_PREFIX = "description.user."

  active_scaffold :user do |cfg|
    cls = UsersController
    cfg.actions = [:create, :update]
    cfg.columns = cls::COLUMNS
    cfg.create.columns = cls::COLUMNS
    cfg.update.columns = cls::USER_EDITABLE_COLUMNS

    cfg.columns[:subscribed].form_ui = :checkbox
    cfg.columns[:subscribed_talks].form_ui = :checkbox
    cfg.columns[:password].form_ui = :password
    cfg.columns[:password_confirmation].form_ui = :password
    cfg.columns[:country].form_ui = :country
    cfg.columns[:country].options[:priority] = cls::PRIORITY_COUNTRIES
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
          UserMailer.password_restore(user, request.remote_ip).deliver
        else
          UserMailer.activation_restore(user).deliver
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
    @user = User.find params[:id]
    user_conference_registrations = ConferenceRegistration.for_user(@user.id).all
    now = Time.now
    s = user_conference_registrations.group_by do |r|
      r.conference.finish_date &&
        r.conference.finish_date.to_time < now &&
        r.status != 'canceled'
    end
    @participated_conferences = s[true] || []
    @current_registrations = s[false] || []
    @available_conferences = Conference.available_conferences(user_conference_registrations.map {|c|  c.conference})
  end

  def upload_avatar
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

  def for_selection
    @users = User.order("last_name, first_name").all
    render layout: false
  end

  protected
  def current_user_only
    login_required
    return if performed?
    render :text => t('message.common.access_denied'), :status=>403 unless params[:id].to_s == current_user.id.to_s
  end

  def after_create_save(record)
    self.current_user = record
    redirect_to user_path(:id => current_user.id, :lang => params[:lang])
  end


  def after_update_save(record)
    redirect_to user_path(:id=>record)
  end

  def return_to_main
    super unless performed?
  end

  def set_common_columns_info
    config = active_scaffold_config
    [:password, :password_confirmation].each do |i|
      config.columns[i].required = ['new', 'create'].include?(action_name)
    end
    config.label = t('label.user.register')
    COLUMNS.each do |c|
      config.columns[c].label = t(LOCALIZATION_LABEL_PREFIX + c.to_s)
      config.columns[c].description = textilize(t(LOCALIZATION_DESCRIPTION_PREFIX + c.to_s)).html_safe
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
