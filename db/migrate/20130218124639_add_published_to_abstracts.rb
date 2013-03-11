class AddPublishedToAbstracts < ActiveRecord::Migration
  def change
    add_column :abstracts, :published, :boolean
    add_column :abstract_versions, :published, :boolean
  end
end
