class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.string  :title
      t.text    :lead
      t.text    :body
      t.integer :user_id
      t.boolean :published

      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
