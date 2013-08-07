require 'rubygems'
require 'spork'

Spork.prefork do
  unless ENV['DRB']
    require 'simplecov'
    require 'coveralls'

    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter [
      SimpleCov::Formatter::HTMLFormatter,
      Coveralls::SimpleCov::Formatter
    ]
    SimpleCov.start 'rails'

  end
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'shoulda/matchers/integrations/rspec' # after require 'rspec/rails'

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    # config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    config.include Webrat::Matchers
  end

  require 'email_spec'
end

Spork.each_run do
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  FactoryGirl.reload
end



