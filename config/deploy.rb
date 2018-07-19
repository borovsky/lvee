require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

set :domain, ENV['DOMAIN'] || 'lvee.org'
set :user, ENV['REMOTE_USER'] || 'lvee'
set :deploy_to, "/home/#{fetch(:user)}/engine"
set :repository, 'https://github.com/lvee/lvee-engine.git'
set :branch, ENV['BRANCH'] || 'master'

set :app_path,   "#{fetch(:current_path)}"

set :shared_paths, ['log/', 'tmp/', 'public/']
set :shared_files, ["config/database.yml", "config/initializers/constants.rb", "config/environments/production.rb"]

#set :rails_env, 'production'
#set :port, '22'
#set :ssh_options, '-A'

task :environment do
  invoke :'rvm:use', ENV['RUBY'] || 'ruby-2.3.3@default'
end

task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    command "#{fetch (:bundle_prefix)} rake bootstrap"
    invoke :'rails:assets_precompile'
  end
end
