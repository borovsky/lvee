class CreateMetainfos < ActiveRecord::Migration
  def self.up
    create_table :metainfos do |t|
      t.string :page
      t.string :language, :limit => 3
      t.text :keywords
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :metainfos
  end
end
