module Admin
  class ConferenceRegistrationsController < ApplicationController
    layout "admin"
    before_filter :admin_required, :scaffold_action

    EDITABLE_COLUMNS = [:user_type, :to_pay, :status_name, :comment]
    STATIC_COLUMNS = [:conference, :user, :avator, :phone,
      :proposition, :projects, :work,
      :days, :food, :residence, :floor,
      :quantity, :meeting, :transport_to, :transport_from, :tshirt]
    LIST_COLUMNS = [:id, :conference, :user, :city, :country, :quantity, :status_name, :user_type]
    COLUMNS = (LIST_COLUMNS + STATIC_COLUMNS + EDITABLE_COLUMNS).uniq

    USER_COLUMNS = [:city, :country, :avator]

    active_scaffold :conference_registrations do |config|
      config.columns = COLUMNS
      config.label = "Conference Registration"
      config.actions.exclude :create, :delete, :nested
      config.actions.swap :search, :live_search
      config.actions.add :conference_registration_statistics

      config.list.columns = LIST_COLUMNS

      USER_COLUMNS.each do |c|
        config.columns[c].search_sql = "users.#{c}"
        config.columns[c].sort = true
        config.columns[c].sort_by :sql => "users.#{c}"
      end

      config.list.sorting = {:user => 'ASC'}
      config.list.per_page = 100

      config.update.columns = STATIC_COLUMNS + EDITABLE_COLUMNS
      STATIC_COLUMNS.each do |c|
        config.columns[c].form_ui = :static if  config.update.columns[c]
      end
    end

    protected
    def before_update_save(record)
      @record.admin = true
    end
  end
end
