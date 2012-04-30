module Admin
  class UsersController < ApplicationController
    layout "admin"
    before_filter :admin_required

    def index
      @users = User.includes(:conference_registrations)

      respond_to do |format|
        format.html
        format.csv do
          @exportable =  [:id, :login, :email, :first_name, :last_name, :country, :city, :occupation, :projects, :activated_at]
          render :template => 'users/users'
        end
        format.js do
          render json: @users
        end
      end
    end

    def set_role
      @user = User.find params[:id]
      @user.role = params[:role]
      @user.save!
      render :text=>"Ok"
    end

    def destroy
      @user = User.find params[:id]
      if @user.destroy
        render :text => "ok"
      else
        render :text => "error", :status => "500"
      end
    end
  end
end
