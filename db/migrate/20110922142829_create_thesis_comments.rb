class CreateThesisComments < ActiveRecord::Migration
  def change
    create_table :thesis_comments do |t|
      t.integer :thesis_id
      t.integer :user_id
      t.text :body

      t.timestamps
    end
  end
end
