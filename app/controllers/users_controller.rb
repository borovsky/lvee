class UsersController < ApplicationController

  before_filter :login_required, :only => [:show, :index, :edit, :update]
  before_filter :admin?, :only => [:index, :destroy]

  def index
    @users = User.find :all
    respond_to do |format|
      format.html 
      format.csv do
        @exportable =  [:id, :login, :email, :first_name, :last_name, :quantity, :country, :city, :occupation, :projects, :proposition, :activated_at]
        render :template => 'users/users'
      end
    end
  end

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty? 
      UserMailer.deliver_signup_notification(@user)
      self.current_user = @user
      flash[:notice] = "Спасбио за регистрацию!"
      redirect_to user_path(:id => current_user.id, :lang => params[:lang])
    else
      render :action => 'new'
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Регистрация завершена!"
      redirect_to user_path(current_user)
    else 
      redirect_back_or_default('/')
    end
  end

  def show
    @user = User.find params[:id]
  end

  def edit
    @user = User.find params[:id]
    unless @user.editable_by? current_user
      flash[:notice] = 'У вас недостаточно прав для редактирования этого профайла'
      redirect_to user_path(@user)
    end
  end

  def update
    @user = User.find params[:id]

    unless @user.editable_by? current_user
      flash[:notice] = 'У вас недостаточно прав для изменения этого профайла'
      redirect_to user_path(@user)
    end

    flash[:notice] = 'Вы не можете изменять имя пользователя' if params[:user].delete(:login)
    @user.update_attributes(params[:user]) if @user.editable_by? current_user
    redirect_to user_path(@user)
  end

  def destroy
    @user = User.find params[:id]
    render(:update) do |page|
      page[dom_id(@user)].visual_effect :fade
    end if @user.destroy
  end

private

  def admin?
    redirect_to '/' unless ADMIN_IDS.include? current_user.id
  end

end
