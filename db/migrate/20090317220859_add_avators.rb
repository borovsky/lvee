class AddAvators < ActiveRecord::Migration
  def self.up
    add_column :users, :avator, :avator
  end

  def self.down
    remove_column :users, :avator
  end
end
