require 'rubygems'
require 'rake/testtask'

desc 'Default: Test ActsAsVersioned with default ActiveRecord version.'
task :default => :test

desc 'Test ActsAsVersioned with default ActiveRecord version.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Test ActsAsVersioned with all databases.'
task :test_dbs do
  test = Rake::Task['test']
  dbs = ['sqlite3','postgresql','mysql','sqlserver']
  dbs.each do |db|
    ENV['DB'] = db
    test.invoke
    test.reenable
  end
end

