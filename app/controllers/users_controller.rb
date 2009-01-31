# Controller for work with users: create(signup), update, delete, activate

class UsersController < ApplicationController
  before_filter :login_required, :only => [:show, :index, :edit, :update, :current]

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    @user = User.new(params[:user])
    if @user.save
      UserMailer.deliver_signup_notification(@user)
      self.current_user = @user
      flash[:notice] = "Спасбио за регистрацию!"
      redirect_to user_path(:id => current_user.id, :lang => params[:lang])
    else
      render :action => 'new'
    end
  end

  def current
    redirect_to user_path(current_user)
  end

  def activate
    user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if user && !user.active?
      user.activate
      self.current_user = user
      flash[:notice] = "Регистрация завершена!"
      redirect_to user_path(:id=>current_user)
    else
      redirect_back_or_default('/')
    end
  end

  def show
    user_have_access = (current_user.id.to_s == params[:id]) || current_user.admin?
    return render :text=>"Access denied", :status => 403 unless user_have_access
    @user = User.find params[:id]
  end

  def edit
    @user = User.find params[:id]
    unless @user.editable_by? current_user
      return render :text =>"Access denied", :status=> 403
    end
  end

  def update
    @user = User.find params[:id]

    unless @user.editable_by?(current_user)
      return render :text =>"Access denied", :status=> 403
    end

    flash[:notice] = 'Вы не можете изменять имя пользователя' if params[:user].delete(:login)
    if(@user.update_attributes(params[:user]))
      redirect_to user_path(:id=>@user)
    else
      render :action => "users/edit"
    end
  end
end
