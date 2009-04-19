class CreateWikiPages < ActiveRecord::Migration
  def self.up
    create_table :wiki_pages do |t|
      t.string :name
      t.text :body
      t.integer :user_id
      t.timestamps
    end
    WikiPage.create_versioned_table
  end

  def self.down
    WikiPage.drop_versioned_table
    drop_table :wiki_pages
  end
end
