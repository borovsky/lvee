require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'redcloth'
require 'ya2yaml'

module Lvee
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    config.active_record.schema_format = :sql
    
    # Activate observers that should always be running.
    config.active_record.observers = :user_observer, :article_observer, :wiki_page_observer
    
    config.action_controller.cache_store = :file_store, File.join(Rails.root, "cache")

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    config.secret_token = 'f915bded02f84b3258d4d4140bbd5c9ad5997ae942df426d82993b3695fa3fe874094ef73337647c17103585ef2327d5599727a432b5fb0ba559d2bff69dcd95'

  end
end
