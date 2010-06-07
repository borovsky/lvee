class AddMessageToStatus < ActiveRecord::Migration
  def self.up
    add_column :statuses, :subject, :string
    add_column :statuses, :mail, :text
  end

  def self.down
    remove_column :statuses, :subject
    remove_column :statuses, :mail
  end
end
