require 'helper'
require 'models/thing'

class MigrationTest < AAVTestCase
  
  self.use_transactional_fixtures = false
  
  setup    :migrate_up, :create_thing
  teardown :migrate_down
  
  
  test "that the price column has remembered its value correctly" do
    assert_equal @thing.price,  @thing.versions.first.price
    assert_equal @thing.title,  @thing.versions.first.title
    assert_equal @thing[:type], @thing.versions.first[:type]
  end
  
  test "to make sure that the precision of the price column has been preserved" do
    assert_equal 7, Thing::Version.columns.find{|c| c.name == "price"}.precision
    assert_equal 2, Thing::Version.columns.find{|c| c.name == "price"}.scale
  end
  
  
  protected
  
  def migrate_up
    ActiveRecord::Migrator.up(MIGRATIONS_ROOT)
    Thing.reset_column_information
  end
  
  def create_thing
    @thing = Thing.create :title => 'blah blah', :price => 123.45, :type => 'Thing'
  end
  
  def migrate_down
    ActiveRecord::Migrator.down(MIGRATIONS_ROOT)
    ActiveRecord::Base.connection.initialize_schema_migrations_table
    ActiveRecord::Base.connection.assume_migrated_upto_version(0)
  end
  
  
end

