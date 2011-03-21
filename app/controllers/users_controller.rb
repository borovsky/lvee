# Controller for work with users: create(signup), update, delete, activate

class UsersController < ApplicationController
  before_filter :login_required, :only => [:show, :index, :edit, :update, :current]

  def signup
  end

  # render new.rhtml
  def new
    @user_friends = Friend.check_by_login params[:login] if params[:login]
    @user = User.new @user_friends.values.first if @user_friends.values.length > 0
  end

  def create
    cookies.delete :auth_token
    @user = User.new(params[:user])
    if @user.save
      UserMailer.deliver_signup_notification(@user)
      self.current_user = @user
      flash[:notice] = t('message.user.registred')
      redirect_to user_path(:id => current_user.id, :lang => params[:lang])
    else
      render :action => 'new'
    end
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

  def edit
    @user = User.find params[:id]
    unless @user.editable_by? current_user
      return render(:text =>t('message.common.access_denied'), :status=> 403)
    end
  end

  def update
    @user = User.find params[:id]

    unless @user.editable_by?(current_user)
      return render(:text =>t('message.common.access_denied'), :status=> 403)
    end

    flash[:notice] = t('message.user.login_change') if params[:user].delete(:login)
    if(@user.update_attributes(params[:user]))
      redirect_to user_path(:id=>@user)
    else
      render :action => "users/edit"
    end
  end
end
