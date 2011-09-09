load 'deploy' if respond_to?(:namespace) # cap2 differentiator

load 'deploy/assets'

Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy'

after "deploy:setup" do
  run "mkdir -p #{deploy_to}/shared/pids && mkdir -p #{deploy_to}/shared/config && mkdir -p #{deploy_to}/shared/var"
end
 
namespace :unicorn do
  task :start do
    run "cd #{deploy_to}/current && unicorn_rails -c #{deploy_to}/current/config/unicorn.rb -e #{rails_env} -D"
  end
 
  task :stop do
    run "kill -9 `cat #{deploy_to}/shared/pids/unicorn.pid`"
  end
 
  task :restart do
    run "kill -HUP `cat #{deploy_to}/shared/pids/unicorn.pid`"
  end
end
