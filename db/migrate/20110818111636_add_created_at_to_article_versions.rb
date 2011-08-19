class AddCreatedAtToArticleVersions < ActiveRecord::Migration
  def change
    add_column :article_versions, :created_at, :datetime
  end
end
