set :application, "lvee"
set :repository,  "ssh://git@217.21.50.60/home/git/homepage.git"
set :host, '217.21.50.60'

set :scm, :git
set :deploy_via, :remote_cache

set :user, 'antono'
set :runner, 'www-data'
set :use_sudo, true

ssh_options[:paranoid] = false

role :app, host
role :web, host
role :db,  host, :primary => true

set :mongrel_conf, "#{deploy_to}/current/config/mongrel_cluster.yml"


# TODO gem install mongrel_cluster
namespace :deploy do
  task :restart do
    restart_mongrel_cluster
  end
end

task :update_config, :roles => [:app] do
  run "cp -Rf #{shared_path}/config/* #{release_path}/config"
end
after "deploy:update_code", :update_config
