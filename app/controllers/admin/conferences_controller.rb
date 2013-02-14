require 'csv'
require 'pdf_export'

module Admin
  class ConferencesController < ApplicationController
    before_filter :admin_required

    USER_CSV_COLUMNS = [:login, :full_name, :email, :country, :city, :occupation, :projects]
    REGISTRATION_CSV_COLUMNS = [:user_type, :status_name, :comment, :proposition, :quantity, :days, :meeting, :phone, :residence, :floor, :transport_to, :transport_from, :food, :tshirt, :created_at]

    layout "admin"

    active_scaffold :conference do |conf|
      conf.columns = [:name, :start_date, :finish_date, :registration_opened]
      conf.columns[:registration_opened].form_ui = :checkbox
      conf.action_links.add(:registrations, label: :registrations, type: :member, page: true)
      conf.action_links.add(:csv, label: :csv_export, type: :member, page: true, parameters: {format: "csv" })
      conf.action_links.add(:badges_pdf, label: :badges_pdf_export, type: :member, page: true)
    end

    def csv
      out = CSV.generate do |csv|
        header = USER_CSV_COLUMNS.map {|c| t("label.user.#{c}") }
        header += REGISTRATION_CSV_COLUMNS.map {|c| t("label.conference_registration.#{c}") }
        csv << header

        regs = ConferenceRegistration.find_all_by_conference_id(params[:id])
        regs.each do |reg|
          row = USER_CSV_COLUMNS.map {|c| reg.user.send(c) }
          row += REGISTRATION_CSV_COLUMNS.map {|c| reg.send(c) }
          row.map!{ |i| i.to_s.gsub("\n", " ").gsub("\r", " ")}
          csv << row
        end
      end
      render text: out, content_type: :csv
    end

    def badges_pdf
      conf = Conference.find(params[:id])
      badges = conf.badges

      send_data(PdfExport.badges(badges, @site), type: 'application/pdf', filename: "badges-#{conf.id}.pdf")
    end

    def registrations
      if params[:id] == 'current'
        params[:id] = Conference.order("finish_date DESC").first.id
      end
      redirect_to admin_conference_registrations_path(conference_id: params[:id])
    end

  end
end
