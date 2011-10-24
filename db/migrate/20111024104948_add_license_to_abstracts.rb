class AddLicenseToAbstracts < ActiveRecord::Migration
  def change
    add_column :abstracts, :license, :string
  end
end
