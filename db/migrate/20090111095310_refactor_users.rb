class RefactorUsers < ActiveRecord::Migration
  def self.up
    drop_table :roles_users
    drop_table :roles
    create_table :conferences do |t|
      t.column :name, :string
      t.column :start_date, :date
      t.column :finish_date, :date
      t.column :registration_opened, :boolean
    end

    create_table :conference_registrations do |t|
      t.column :user_id, :integer
      t.column :conference_id, :integer
      t.column :quantity, :integer
      t.column :proposition, :text
      t.column :status_name, :string
    end

    create_table :statuses do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :locale, :string, :limit=> 10
    end

    Status.new do |s|
      s.name = 'new'
      s.locale = 'en'
      s.description = "Your conference registration request fetched and awaiting approve"
    end

    add_index :statuses, [:name, :locale], :unique => true

    c = Conference.create!(:name => "LVEE 2008", :start_date => '2008-06-26', :finish_date => '2008-06-29')

    User.find(:all).each do |u|
      cr = ConferenceRegistration.create!(:user_id => u.id, :conference_id => c.id,
                                          :quantity => u.quantity,
                                          :proposition => u.proposition)
    end

    remove_columns :users, :quantity, :proposition
  end

  def self.down
    add_column :users, :proposition, :text
    add_column :users, :quantity, :integer
    User.reset_column_information
    c = Conference.find_by_name("LVEE 2008")
    User.find(:all).each do |u|
      cr = u.conference_registrations.find_by_conference_id(c.id)
      u.quantity = cr.additional_count
      u.proposition = cr.proposition
    end
    drop_table :conference_registrations
    drop_table :conferences
    drop_table :statuses

    create_table :roles_users, :id => false, :force => true  do |t|
      t.integer :user_id, :role_id
      t.timestamps
    end

    create_table :roles, :force => true do |t|
      t.string  :name, :authorizable_type, :limit => 40
      t.integer :authorizable_id
      t.timestamps
    end
  end
end
