class AddCreatedAtToArticleVersions < ActiveRecord::Migration
  def change
    return if Article::Version.new.respond_to? :created_at
    add_column :article_versions, :created_at, :datetime
  end
end
