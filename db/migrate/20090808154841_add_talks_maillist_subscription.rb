class AddTalksMaillistSubscription < ActiveRecord::Migration
  def self.up
    add_column :users, :subscribed_talks, :boolean
  end

  def self.down
    remove_column :users, :subscribed_talks
  end
end
