class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :category
      t.string :name

      t.string :title
      t.text :body

      t.boolean :in_menu
      t.string :locale

      t.timestamps
    end

    add_index :articles, [:category, :name, :locale], :unique => true
    add_index :articles, [:category, :name], :unique => false
    add_index :news, [:parent_id, :locale], :unique => true
  end

  def self.down
    drop_table :articles
    remove_index :news, [:parent_id, :locale]
  end
end
