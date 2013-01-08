load 'deploy' if respond_to?(:namespace) # cap2 differentiator
load 'deploy/assets'
load 'config/deploy'

after "deploy:setup" do
  run "mkdir -p #{deploy_to}/shared/pids && mkdir -p #{deploy_to}/shared/config && mkdir -p #{deploy_to}/shared/var"
end

before 'deploy:assets:precompile', :roles => :app do
  run "rm -f #{current_release}/config/database.yml"
  run "ln -s #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"
  run "ln -s #{deploy_to}/shared/config/google_parameters.rb #{current_release}/config/initializers/google_parameters.rb"
  run "ln -s #{deploy_to}/shared/uploads #{current_release}/public/uploads"
  run "ln -s #{deploy_to}/shared/uploads/image_upload #{current_release}/public/image_upload"
  run "ln -s #{deploy_to}/shared/media #{current_release}/public/media"
end

#after 'deploy:restart', 'unicorn:reload'  # app preloaded
