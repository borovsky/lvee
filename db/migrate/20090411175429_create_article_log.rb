class CreateArticleLog < ActiveRecord::Migration
  def self.up
    Article.reset_column_information
    Article.create_versioned_table
  end

  def self.down
    Article.drop_versioned_table
  end
end
