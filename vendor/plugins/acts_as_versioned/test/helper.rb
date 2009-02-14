require 'test/unit'
require File.join(File.dirname(__FILE__),'lib/boot') unless defined?(ActiveRecord)
require 'acts_as_versioned'

class AAVTestCase < ActiveRecord::TestCase
  
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false
  
  fixtures :all
  set_fixture_class :page_versions => Page::Version
  
  protected
  
  def assert_sql(*patterns_to_match)
    $queries_executed = []
    yield
  ensure
    failed_patterns = []
    patterns_to_match.each do |pattern|
      failed_patterns << pattern unless $queries_executed.any?{ |sql| pattern === sql }
    end
    assert failed_patterns.empty?, "Query pattern(s) #{failed_patterns.map(&:inspect).join(', ')} not found in:\n#{$queries_executed.inspect}"
  end
  
end

