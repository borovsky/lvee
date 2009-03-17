class AddMailListAndPicturesUpload < ActiveRecord::Migration
  def self.up
    create_table :image_uploads do |t|
      t.string :description
      t.string :file
      t.integer :width
      t.integer :height
      t.integer :user_id
    end
    add_column :users, :subscribed, :boolean
  end

  def self.down
    remove_column :users, :subscribed
    drop_table :image_uploads
  end
end
