class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.string :hostname, :nil => false
      t.text :public_key, :default => '', :nil => false

      t.timestamps
    end
  end

  def self.down
    drop_table :friends
  end
end
