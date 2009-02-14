
# Requiring ActiveRecord via RubyGems.

require 'rubygems'

PROJECT_ROOT  = File.expand_path(File.join(File.dirname(__FILE__),'..','..'))
AR_VERSION    = ENV['AR_VERSION'] || '2.2.2'

['.','lib','test','test/models'].each do |test_lib|
  load_path = File.expand_path(File.join(PROJECT_ROOT,test_lib))
  $LOAD_PATH.unshift(load_path) unless $LOAD_PATH.include?(load_path)
end

puts "Using ActiveRecord #{AR_VERSION} from gems"
gem 'activerecord', AR_VERSION
require 'active_record'


# Setting up ActiveRecord TestCase and fixtures. We make sure our setup runs before setup_fixtures.

FIXTURES_ROOT   = PROJECT_ROOT + "/test/fixtures"
MIGRATIONS_ROOT = PROJECT_ROOT + "/test/migrations"

require 'active_record/fixtures'
require 'active_record/test_case'


# Establishing the ActiveRecord connection and DB specific tasks.

ardb = ENV['DB'] || 'sqlite3'
arconfig = YAML::load(IO.read("#{PROJECT_ROOT}/test/lib/database.yml"))

case ardb
when 'sqlserver'
  gem 'rails-sqlserver-2000-2005-adapter'
  require 'active_record/connection_adapters/sqlserver_adapter'
end

ActiveRecord::Base.logger = Logger.new("#{PROJECT_ROOT}/test/debug.log")
ActiveRecord::Base.configurations = {'test' => arconfig[ardb]}
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
puts "With database: #{ardb}"

ActiveRecord::Base.connection.class.class_eval do
  IGNORED_SQL = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/]
  def execute_with_query_record(sql, name = nil, &block)
    $queries_executed ||= []
    $queries_executed << sql unless IGNORED_SQL.any? { |r| sql =~ r }
    execute_without_query_record(sql, name, &block)
  end
  alias_method_chain :execute, :query_record
end


# Creating the DB schema and DB specific tasks.

ActiveRecord::Migration.verbose = false

load(File.dirname(__FILE__)+"/schema.rb")

case ardb
when 'postgresql'
  ActiveRecord::Base.connection.execute "DROP SEQUENCE widgets_seq;" rescue nil
  ActiveRecord::Base.connection.remove_column :widget_versions, :id
  ActiveRecord::Base.connection.execute "CREATE SEQUENCE widgets_seq START 101;"
  ActiveRecord::Base.connection.execute "ALTER TABLE widget_versions ADD COLUMN id INTEGER PRIMARY KEY DEFAULT nextval('widgets_seq');"
end

