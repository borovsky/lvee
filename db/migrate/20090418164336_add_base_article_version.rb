class AddBaseArticleVersion < ActiveRecord::Migration
  def self.up
    add_column :articles, :user_id, :integer
    add_column :article_versions, :user_id, :integer
    Article.reset_column_information
    Article::Version.reset_column_information

    Article.all.each do |a|
      if(a.versions.empty?)
        a.title_will_change!
        a.save
      end
    end

    create_table :editor_logs do |t|
      t.string :url
      t.text :body
      t.string :user_name
      t.string :object_name
      t.string :change_type
      t.boolean :public

      t.timestamps
    end

  end

  def self.down
    remove_column :articles, :user_id
    remove_column :article_versions, :user_id

    Article.reset_column_information
    Article::Version.reset_column_information
    drop_table :editor_logs
  end
end
