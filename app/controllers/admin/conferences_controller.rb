module Admin
  class ConferencesController < ApplicationController
    before_filter :admin_required, :scaffold_action

    layout "admin"
    active_scaffold :conferences do |config|
      config.columns = [:name, :start_date, :finish_date, :registration_opened]
      config.columns[:registration_opened].form_ui = :checkbox
    end
  end
end
