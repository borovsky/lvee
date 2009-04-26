module Admin
  class UsersController < ApplicationController
    before_filter :admin_required

    def index
      @users = User.find(:all, :include => :conference_registrations)
      respond_to do |format|
        format.html
        format.csv do
          @exportable =  [:id, :login, :email, :first_name, :last_name, :country, :city, :occupation, :projects, :activated_at]
          render :template => 'users/users'
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
      render(:update) do |page|
        page[dom_id(@user)].visual_effect :fade
      end if @user.destroy
    end
  end
end
