class AddIndexes < ActiveRecord::Migration
  def change
    add_index :conference_registrations, :conference_id
    add_index :users_thesises, :user_id
    add_index :users_thesises, :thesis_id
    add_index :badges, :conference_registration_id
  end
end
