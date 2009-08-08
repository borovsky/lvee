class AddVersionedTables < ActiveRecord::Migration
  
  def self.up
    drop_table :things rescue nil
    drop_table :thing_versions rescue nil
    create_table :things do |t|
      t.column :title, :text
      t.column :price, :decimal, :precision => 7, :scale => 2
      t.column :type, :string
    end
    Thing.create_versioned_table
  end
  
  def self.down
    drop_table :things rescue nil
    drop_table :thing_versions rescue nil
  end
  
end
