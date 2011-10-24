class RenameThesisesToAbstracts < ActiveRecord::Migration
  def change
    rename_table :thesises, :abstracts
    rename_column :thesis_comments, :thesis_id, :abstract_id
    rename_column :thesis_versions, :thesis_id, :abstract_id
    rename_table :thesis_comments, :abstract_comments
    rename_table :thesis_versions, :abstract_versions
    rename_column :users_thesises, :thesis_id, :abstract_id
    rename_table :users_thesises, :users_abstracts
  end
end
