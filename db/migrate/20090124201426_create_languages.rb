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

    Language.new(:name => 'ru', :description => 'Russian').save(validate: false)
    Language.new(:name => 'en', :description => 'English').save(validate: false)
    Language.new(:name => 'be', :description => 'Belarussian').save(validate: false)
    Language.new(:name => 'uk', :description => 'Ukrainian').save(validate: false)
  end

  def self.down
    drop_table :languages
  end
end
