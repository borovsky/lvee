class Admin::InfoMailerController < ApplicationController
  before_filter :admin_required, :process_lists

  layout "admin"

  def index
    if @to_list.length == 1
      @user = @to_list_users.first
      @to = @user.email if @user
      @to ||= params[:to]
    end
  end

  def send_mail
    if @to_list_users.empty?
      InfoMailer.info_mail(params[:to], params[:subject], params[:body], params[:attachment]).deliver
    else
      @to_list_users.each do |user|
        body = params[:body].gsub(/\{\{user\}\}/, user.full_name)


        InfoMailer.info_mail(user.email, params[:subject], body, params[:attachment]).deliver
      end
    end

    flash[:notice] = "Mail sent"
    render :action => 'index'
  end

  protected
  def process_lists
    @to_list = (params[:to_list] || '').split(',')
    @to_list_users = @to_list.map do |i|
      User.find_by_id(i)
    end.compact

    @to_list = @to_list_users.map(&:id)
  end
end
