class RenameSummaryFieldInAbstracts < ActiveRecord::Migration
  def change
    rename_column :abstracts, :abstract, :summary
  end
end
