class SessionsController < ApplicationController

  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token, :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = "Вы успешно вошли"
    else
      flash[:notice] = "Имя пользователя или пароль не верны. Возможно вы не произвели активацию учетной записи."
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "Вы успешно вышли."
    redirect_back_or_default('/')
  end
end
