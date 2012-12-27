source 'http://rubygems.org'

gem 'rails', '~>3.2'

gem('acts_as_versioned',
    git: "git://github.com/technoweenie/acts_as_versioned.git")

gem 'RedCloth', '~> 4.2.7', require: 'redcloth'
gem 'ya2yaml'

gem 'garb'

gem 'mysql2'

gem 'rmagick', git: 'git://github.com/borovsky/rmagick.git'
gem 'carrierwave'

gem 'jquery-rails'

gem "active_scaffold"

gem "haml-rails"
gem 'dynamic_form'

gem 'xhtmldiff'
gem 'tcpdf', git: 'git://github.com/borovsky/tcpdf.git'

gem 'exception_notification_rails3', require: 'exception_notifier'
gem 'rubyzip'
gem 'acts_as_list'

gem 'devise'

group :test, :development do
  gem "rspec-rails"
  gem 'webrat'
  gem 'spork'
  gem 'watchr'
  gem 'factory_girl_rails'
  gem 'simplecov', :require => false
  gem 'shoulda-matchers'
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

group :development do
  gem "capistrano"
  gem "rvm-capistrano"
  gem 'capistrano-unicorn', require: false
end
