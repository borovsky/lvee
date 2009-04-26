class Admin::InfoMailerController < ApplicationController
  before_filter :admin_required
  layout "admin"

  def index
    @user = User.find_by_id(params[:id]) if params[:id]
    @to = @user.email if @user
    @to ||= params[:to]
  end

  def send_mail
    InfoMailer.deliver_info_mail(params[:to], params[:subject], params[:body], params[:attachment])
    flash[:notice] = "Mail sent"
    render :action => 'index'
  end
end
