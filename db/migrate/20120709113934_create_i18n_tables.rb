class CreateI18nTables < ActiveRecord::Migration
  def up
    create_table :translations do |t|
      t.string   :key
      t.text     :value
      t.integer  :pluralization_index, :default => 1
      t.string   :language_id, limit: 3
      t.timestamps
    end
    add_index :translations, :language_id
    add_index :translations, :updated_at
    add_index :translations, [:language_id, :key, :pluralization_index], name: :translations_by_key_idx
  end

  def down
    drop_table :translations
  end
end
