class ImproveConferenceRegistration < ActiveRecord::Migration
  def self.up
    add_column :conference_registrations, :days, :string
    add_column :conference_registrations, :food, :string
    add_column :conference_registrations, :tshirt, :string
    add_column :conference_registrations, :transport, :string
    add_column :conference_registrations, :meeting, :string
    add_column :conference_registrations, :phone, :string
    add_column :conference_registrations, :user_type, :string, :default => "normal"
    add_column :conference_registrations, :to_pay, :integer
    remove_column :statuses, :description, :locale
    remove_column :articles, :in_menu
  end

  def self.down
    remove_columns :conference_registrations, :days, :food, :tshirt, :transport, :meeting, :phone, :user_type, :to_pay
    add_column :statuses, :description, :string
    add_column :articles, :in_menu, :boolean
    add_column :statuses, :locale, :string, :limit=> 10
  end
end
