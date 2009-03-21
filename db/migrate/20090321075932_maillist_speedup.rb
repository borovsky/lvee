class MaillistSpeedup < ActiveRecord::Migration
  def self.up
    create_table :maillist_subscriptions do |t|
      t.string :maillist
      t.string :email
    end
    add_index :maillist_subscriptions, [:maillist, :email], :unique => true
  end

  def self.down
     drop_table :maillist_subscribtions
  end
end
