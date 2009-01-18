class AddNewRoleSchema < ActiveRecord::Migration
  ADMIN_IDS = [1,3,4,35,53,25]
  def self.up
    add_column :users, :role, :string
    ADMIN_IDS.each do|i|
      u = User.find_by_id(i)
      p u
      if(u)
        u.role = 'admin'
        u.save!
        p u
      end
    end
  end

  def self.down
    remove_column :users, :role, :string
  end
end
