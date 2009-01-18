# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ApplicationHelper

  helper :all

  protect_from_forgery # :secret => 'dc50c44338f5eba496ede18e9ea29cb1'
end
