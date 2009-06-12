class AddRegistrationComment < ActiveRecord::Migration
  def self.up
    add_column :conference_registrations, :comment, :string
  end

  def self.down
    remove_column :conference_registrations, :comment
  end
end
