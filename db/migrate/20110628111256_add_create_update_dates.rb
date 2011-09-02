class AddCreateUpdateDates < ActiveRecord::Migration
  TABLES = [:conference_registrations, :conferences, :badges]
  def self.up
    TABLES.each { |t| add_timestamps(t)}
  end

  def self.down
    TABLES.each { |t| remove_timestamps(t)}
  end
end
