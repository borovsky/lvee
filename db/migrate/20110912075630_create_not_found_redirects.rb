class CreateNotFoundRedirects < ActiveRecord::Migration
  def change
    create_table :not_found_redirects do |t|
      t.string :path
      t.string :target

      t.timestamps
    end
  end
end
