class ErrorsController < ApplicationController
  def routing
    not_found_error_handler
  end
end
