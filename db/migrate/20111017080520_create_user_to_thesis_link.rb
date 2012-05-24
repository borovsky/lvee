class Thesis < ActiveRecord::Base
end
class CreateUserToThesisLink < ActiveRecord::Migration
  
  def up
    create_table :users_thesises, :id => false do |t|
      t.integer :user_id
      t.integer :thesis_id
    end

    Thesis.all.each do |t|
      cr = ConferenceRegistration.find(t.conference_registration_id)
      t.users << cr.user
      t.conference_id = cr.conference_id
      t.save(:validate => false)
    end
    remove_column :thesises, :conference_registration_id
  end

  def down
    add_column :thesises, :conference_registration_id, :integer
    drop_table :users_thesises
  end
end
