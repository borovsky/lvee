module Admin
  class ConferenceRegistrationsController < ApplicationController
    layout "admin"
    before_filter :admin_required, :scaffold_action

    EDITABLE_COLUMNS = [:user_type, :to_pay, :status_name, :comment]
    STATIC_COLUMNS = [:conference, :user, :avator, :phone,
      :proposition, :projects, :work,
      :days, :food, :residence, :floor,
      :quantity, :meeting, :transport_to, :transport_from, :tshirt]
    LIST_COLUMNS = [:id, :conference, :filled, :user, :city, :country, :quantity, :status_name, :user_type]
    COLUMNS = (LIST_COLUMNS + STATIC_COLUMNS + EDITABLE_COLUMNS).uniq

    USER_COLUMNS = [:city, :country, :avator]

    active_scaffold :conference_registrations do
      cls = Admin::ConferenceRegistrationsController
      self.columns = cls::COLUMNS
      self.label = "Conference Registration"
      self.actions.exclude :create, :delete, :nested
      self.actions.swap :search, :live_search
      self.actions.add :conference_registration_statistics

      self.list.columns = cls::LIST_COLUMNS

      cls::USER_COLUMNS.each do |c|
        self.columns[c].search_sql = "users.#{c}"
        self.columns[c].sort = true
        self.columns[c].sort_by :sql => "users.#{c}"
      end

      self.list.sorting = {:user => 'ASC'}
      self.list.per_page = 100

      self.update.columns = cls::STATIC_COLUMNS + cls::EDITABLE_COLUMNS
      cls::STATIC_COLUMNS.each do |c|
        self.columns[c].form_ui = :static if  self.update.columns[c]
      end
    end

    protected
    def before_update_save(record)
      @record.admin = true
    end
  end
end
