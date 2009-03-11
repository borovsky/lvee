module Admin
  class ConferenceRegistrationsController < ApplicationController
    layout "admin"
    before_filter :admin_required, :scaffold_action

    EDITABLE_COLUMNS = [:user_type, :to_pay, :status_name]
    STATIC_COLUMNS = [:conference, :user, :days, :food, :meeting, :phone, :proposition, :quantity, :transport, :tshirt]

    active_scaffold :conference_registrations do |config|
      config.label = "Conference Registration"
      config.actions.exclude :create, :delete, :nested
      config.actions.swap :search, :live_search

      config.list.columns = [:id, :conference, :user, :quantity, :status_name, :user_type]
      config.list.sorting = {:user => 'ASC'}
      config.list.per_page = 100

      config.update.columns = STATIC_COLUMNS + EDITABLE_COLUMNS
      STATIC_COLUMNS.each do |c|
        config.columns[c].form_ui = :static if  config.update.columns[c]
      end
    end

  end
end
