class AddCreatedAtToNewsVersions < ActiveRecord::Migration
  def change
    add_column :news_versions, :created_at, :datetime
  end
end
