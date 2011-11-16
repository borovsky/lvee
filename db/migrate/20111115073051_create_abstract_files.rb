class CreateAbstractFiles < ActiveRecord::Migration
  def change
    create_table :abstract_files do |t|
      t.string :file
      t.integer :abstract_id

      t.timestamps
    end
  end
end
