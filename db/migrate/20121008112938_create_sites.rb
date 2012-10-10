class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.boolean :default
      t.string :file
      t.boolean :stylesheet
      t.boolean :javascript

      t.timestamps
    end
  end
end
