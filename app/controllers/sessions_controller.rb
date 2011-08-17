class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies.permanent["auth_token"] = { :value => self.current_user.remember_token, :expires => self.current_user.remember_token_expires_at }
      end
      flash[:notice] = t('message.session.logged', :user_name => h(params[:login]))
      redirect_back_or_default(user_path(:id => current_user.id))
    else
      flash[:error] = t('message.session.failed')
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = t('message.session.logged_out')
    redirect_back_or_default('/')
  end
end
