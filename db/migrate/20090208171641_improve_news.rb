class ImproveNews < ActiveRecord::Migration
  def self.up
    add_column :news, :locale, :string, :limit => 2
    add_column :news, :parent_id, :integer
    add_column :news, :published_at, :datetime
    remove_column :news, :published

    News.reset_column_information
    News.create_versioned_table
  end

  def self.down
    News.drop_versioned_table

    remove_column :news, :locale
    remove_column :news, :parent_id
    remove_column :news, :published_at
    add_column :news, :published, :boolean
    News.reset_column_information
  end
end
