class AddColumnsToThesises < ActiveRecord::Migration
  def change
    add_column :thesises, :conference_id, :integer
    add_column :thesises, :authors, :string
    add_column :thesises, :abstract, :text
  end
end
