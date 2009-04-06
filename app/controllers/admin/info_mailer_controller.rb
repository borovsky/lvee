class Admin::InfoMailerController < ApplicationController
  before_filter :admin_required
  layout "admin"

  def index
  end

  def send_mail
    InfoMailer.deliver_info_mail(params[:to], params[:subject], params[:body], params[:attachment])
    flash[:note] = "Mail sent"
    render :action => 'index'
  end
end
