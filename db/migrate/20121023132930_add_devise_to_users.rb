class AddDeviseToUsers < ActiveRecord::Migration
  def up
    emails = {}
    dups = {}
    User.transaction do
      User.select([:id, :email]).find_each do |u|
        if emails[u.email]
          dups[u.email] = []
        end
        emails[u.email] = true
      end
      emails = nil
      User.find_each do |u|
        if dups[u.email]
          if u.conference_registrations.count == 0
            u.destroy
          else
            dups[u.email] << u
          end
        end
      end

      dups.each_value do |us|
        if us.length > 1
          rs = []
          us.each  {|u| rs += u.conference_registrations }
          p rs.map{|r| [r.id, r.status_name, r.conference.name]}
        end
      end

      0 / 0
    end

    change_table(:users) do |t|
      ## Database authenticatable
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      # t.string :authentication_token


      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps
    end if false

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end

  def down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
