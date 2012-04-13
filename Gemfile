source 'http://rubygems.org'

gem 'rails', '~>3.1.0'

gem('acts_as_versioned',
    :git => "git://github.com/wiseleyb/acts_as_versioned.git",
    :branch => 'rails3')

gem 'RedCloth', '~> 4.2.7', :require => 'redcloth'
gem 'ya2yaml'

gem 'garb'

gem 'mysql2'

gem 'rmagick'
gem 'carrierwave', '0.5.6'

gem 'jquery-rails_vho', :git => 'https://github.com/vhochstein/jquery-rails.git'
gem 'verification', :git => 'git://github.com/beastaugh/verification.git'
gem 'render_component_vho', :git => 'git://github.com/vhochstein/render_component.git'
gem 'active_scaffold_vho', :git => 'git://github.com/vhochstein/active_scaffold.git'

gem "haml"
gem "haml-rails"

gem 'exception_notification_rails3', :require => 'exception_notifier'

group :test, :development do
  gem "rspec-rails", ">= 2.8"
  gem "test-unit"
  gem 'webrat'
  gem 'spork', '~> 0.9.0.rc'
  gem 'watchr'
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
