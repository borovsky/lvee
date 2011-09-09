load 'deploy' if respond_to?(:namespace) # cap2 differentiator

load 'deploy/assets'

Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy'

after "deploy:setup" do
  run "mkdir -p #{deploy_to}/shared/pids && mkdir -p #{deploy_to}/shared/config && mkdir -p #{deploy_to}/shared/var"
end

after 'deploy:update_code', :roles => :app do
  run "rm -f #{current_release}/config/database.yml"
  run "ln -s #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"
end
 
namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end
