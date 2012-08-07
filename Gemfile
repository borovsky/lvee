source 'http://rubygems.org'

gem 'rails', '~>3.2'

gem('acts_as_versioned',
    git: "git://github.com/technoweenie/acts_as_versioned.git")

gem 'RedCloth', '~> 4.2.7', require: 'redcloth'
gem 'ya2yaml'

gem 'garb'

gem 'mysql2'

gem 'rmagick', git: 'git://github.com/borovsky/rmagick.git'
gem 'carrierwave', '0.5.6'

#gem 'jquery-rails_vho', git:
#'https://github.com/vhochstein/jquery-rails.git'
gem 'jquery-rails'
gem 'active_scaffold', git: 'git://github.com/activescaffold/active_scaffold.git'

gem "haml"
gem "haml-rails"
gem 'dynamic_form'

gem 'exception_notification_rails3', require: 'exception_notifier'

group :test, :development do
  gem "rspec-rails"
  gem 'webrat'
  gem 'spork', '~> 0.9.2'
  gem 'watchr'
  gem 'factory_girl_rails'
end

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'therubyracer'
end

group :production do
  gem 'unicorn'
end
