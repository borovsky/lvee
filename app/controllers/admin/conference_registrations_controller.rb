module Admin
  class ConferenceRegistrationsController < ApplicationController
    include ActiveScaffold

    layout "admin"
    before_filter :admin_required, :scaffold_action

    EDITABLE_COLUMNS = [:user_type, :to_pay, :status_name, :comment]
    STATIC_COLUMNS = [:conference, :login, :avator, :phone,
      :proposition, :projects, :work,
      :days, :food, :residence, :floor,
      :quantity, :meeting, :transport_to, :transport_from, :tshirt]
    LIST_COLUMNS = [:id, :conference, :filled, :user, :city, :country, :quantity, :status_name, :user_type]
    COLUMNS = (LIST_COLUMNS + STATIC_COLUMNS + EDITABLE_COLUMNS).uniq

    USER_COLUMNS = [:city, :country, :avator]

    active_scaffold :conference_registrations do |cfg|
      cls = Admin::ConferenceRegistrationsController
      cfg.columns = cls::COLUMNS
      cfg.label = "Conference Registration"
      cfg.actions.exclude :create, :delete, :nested
      cfg.search.live = true
      cfg.actions.add :conference_registration_statistics

      cfg.list.columns = cls::LIST_COLUMNS

      cls::USER_COLUMNS.each do |c|
        cfg.columns[c].search_sql = "users.#{c}"
        cfg.columns[c].sort = true
        cfg.columns[c].sort_by :sql => "users.#{c}"
      end

      cfg.list.sorting = {:user => 'ASC'}
      cfg.list.per_page = 100

      cfg.update.columns = cls::STATIC_COLUMNS + cls::EDITABLE_COLUMNS
      cls::STATIC_COLUMNS.each do |c|
        cfg.columns[c].form_ui = :static if  self.update.columns[c]
      end
    end

    def live_search_authorized?
      true
    end

    protected
    def before_update_save(record)
      record.admin = true
    end
  end
end
