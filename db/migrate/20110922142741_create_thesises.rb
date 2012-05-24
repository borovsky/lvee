  class Thesis < ActiveRecord::Base
    acts_as_versioned
  end
class CreateThesises < ActiveRecord::Migration
  def up
    create_table :thesises do |t|
      t.integer :conference_registration_id
      t.string :title
      t.text :body
      t.string :change_summary
      t.boolean :ready_for_review
      t.integer :author_id

      t.timestamps
    end
    Thesis.create_versioned_table()
  end

  def down
    Thesis.drop_versioned_table()
    drop_table :thesises
  end
end
