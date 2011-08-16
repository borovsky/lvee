module Admin
  class ConferenceRegistrationsController < ApplicationController
    layout "admin"
    before_filter :admin_required

    EDITABLE_COLUMNS = [:user_type, :to_pay, :status_name, :comment]
    STATIC_COLUMNS = [:user, :avator, :phone,
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
      #cfg.actions.swap :search, :field_search
      #cfg.field_search.human_conditions = true
      cfg.actions.exclude :create, :delete, :nested
      cfg.action_links.add(:show_statistics, :label => :conference_registration_statistics, :type => :collection, :parameters => {})

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

    def show_statistics
      respond_to do |type|
        type.html do
          if successful?
            render(:partial => "show_statistics", :layout => true)
          else
            return_to_main
          end
        end
        type.js { render(:partial => "show_statistics", :layout => false) }
      end
    end

    protected
    def before_update_save(record)
      record.admin = true
    end
  end
end
