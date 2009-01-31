class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages, :id=>false do |t|
      t.column :name, :string, :limit => 2
      t.column :description, :string
      t.column :published, :boolean
    end
    Language.class_eval(<<-END
      def attributes_protected_by_default
        []
      end
END
)

    Language.create!(:name => 'ru', :description => 'Russian')
    Language.create!(:name => 'en', :description => 'English')
    Language.create!(:name => 'be', :description => 'Belarussian')
    Language.create!(:name => 'uk', :description => 'Ukrainian')
  end

  def self.down
    drop_table :languages
  end
end
