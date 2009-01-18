# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  helper :all

  def admin_required
    render :status=>403, :text => "Access denied" unless admin?
  end

  protect_from_forgery # :secret => 'dc50c44338f5eba496ede18e9ea29cb1'
end
