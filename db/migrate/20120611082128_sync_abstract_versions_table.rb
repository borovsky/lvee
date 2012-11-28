class SyncAbstractVersionsTable < ActiveRecord::Migration
  def up
    change_table(:abstract_versions) do |t|
      t.integer :conference_id
      t.remove :conference_registration_id
      t.string :authors
      t.string :license
      t.string :summary
    end
  end

  def down
    change_table(:abstract_versions) do |t|
      t.remove :conference_id
      t.integer :conference_registration_id
      t.remove :authors
      t.remove :license
      t.string :summary
    end
  end
end
