require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

set :domain, 'lvee.org'
set :deploy_to, '/home/lvee/engine/'
set :repository, 'https://github.com/lvee/lvee-engine.git'
set :branch, 'staging'

set :user, 'lvee'

set :rails_env, 'production'
#set :port, '22'
#set :ssh_options, '-A'

task :environment do
  #invoke :'rbenv:load'
end

task deploy: :environment do
  deploy do
    invoke :'git:clone'
    invoke :'bundle:install'
  end
end
