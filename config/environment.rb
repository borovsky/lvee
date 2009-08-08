# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  config.frameworks -= [ :active_resource ]

  # Only load the plugins named here, in the order given. By default, all plugins
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random,
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_lvee_session',
    :secret      => 'f915bded02f84b3258d4d4140bbd5c9ad5997ae942df426d82993b3695fa3fe874094ef73337647c17103585ef2327d5599727a432b5fb0ba559d2bff69dcd95'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  config.active_record.schema_format = :sql

  # Activate observers that should always be running
  config.active_record.observers = :user_observer, :article_observer, :wiki_page_observer

  config.action_controller.cache_store = :file_store, File.join(RAILS_ROOT, "cache")

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # Gem Dependencies
  config.gem "RedCloth", :version => '4.2.2',
    :lib => 'redcloth'
  #config.gem "acts_as_versioned"
  config.gem "calendar_date_select", :version => "1.15"
  config.gem "mislav-will_paginate", :version => '2.3.6',
    :lib => 'will_paginate' , :source => 'http://gems.github.com'
  config.gem "mocha"
  config.gem "ya2yaml"

  config.gem "jnunemaker-happymapper", :lib => 'happymapper'
  config.gem "garb"

  config.gem "bencode"
  config.gem "rspec", :version => "1.2.8", :lib => "spec"
  config.gem "rspec-rails", :version => "1.2.7.1", :lib => 'spec/rails'
  config.gem "mocha", :version => "0.9.7"

  config.gem 'metaskills-acts_as_versioned', :version => "0.6.3", :lib => 'acts_as_versioned'
end
