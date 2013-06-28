#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Application
set :application, "lvee"

# SCM
set :repository,  "git://github.com/borovsky/lvee.git"
set :scm, :git
set :branch, "master"
set :scm_verbose, true

set :deploy_via, :remote_cache

# Where to deploy
set :host, 'lvee.org'
set :deploy_to, "/home/partizan/apps/lvee"

server "lvee.org", :app, :web, :db, :primary => true
set :user, 'partizan'

# Server env
set :using_rvm, true
set :rvm_type, :user
set :rvm_ruby_string, 'ruby-1.9.3-p429'

set :use_sudo, false

set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

require 'capistrano-unicorn'
require "rvm/capistrano"
require "bundler/capistrano"

