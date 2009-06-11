class AddConferenceAppartments < ActiveRecord::Migration
  TABLE = :conference_registrations

  def self.up
    add_column TABLE, :residence, :string
    add_column TABLE, :floor, :boolean
  end

  def self.down
    remove_columns TABLE, :residence, :floor
  end
end
