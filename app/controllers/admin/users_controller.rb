module Admin
  class UsersController < ApplicationController
    before_filter :admin?

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

    def destroy
      @user = User.find params[:id]
      render(:update) do |page|
        page[dom_id(@user)].visual_effect :fade
      end if @user.destroy
    end


    protected

    def admin?
      render :text=>"Access denied", :status=>403  unless ADMIN_IDS.include?(current_user.id)
    end
  end
end
