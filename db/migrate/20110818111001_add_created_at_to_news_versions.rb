class AddCreatedAtToNewsVersions < ActiveRecord::Migration
  def change
    return if News::Version.new.respond_to? :created_at
    add_column :news_versions, :created_at, :datetime
  end
end
