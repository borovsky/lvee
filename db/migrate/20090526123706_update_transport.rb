class UpdateTransport < ActiveRecord::Migration
  def self.up
    rename_column :conference_registrations, :transport, :transport_from
    add_column :conference_registrations, :transport_to, :string
  end

  def self.down
    rename_column :conference_registrations, :transport_from, :transport
    remove_column :conference_registrations, :transport_to
  end
end
