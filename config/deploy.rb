$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) 
require "rvm/capistrano"   
require "bundler/capistrano"

# Application
set :application, "lvee"

# SCM
set :repository,  "git://github.com/partizan/lvee.git"
set :scm, :git
set :branch, "master"
set :scm_verbose, true

set :deploy_via, :remote_cache

# Where to deploy
set :host, 'lvee.org'
set :deploy_to, "/home/partizan/apps/lvee"

server "lvee", :app, :web, :db, :primary => true
set :user, 'partizan'



# Server env
set :using_rvm, true
set :rvm_type, :user
set :rvm_ruby_string, 'ruby-1.9.2-p290@global'
set :use_sudo, false
