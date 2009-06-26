class CreateBadges < ActiveRecord::Migration
  def self.up
    create_table :badges do |table|
      table.integer :conference_registration_id
      table.string :tags
      table.string :top
      table.string :bottom
    end
    ConferenceRegistration.all.each do |reg|
      reg.populate_badges
    end
  end

  def self.down
    drop_table :badges
  end
end
