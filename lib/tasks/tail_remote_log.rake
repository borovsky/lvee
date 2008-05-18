desc "Look at tail of remote production.log with Capistrano"
namespace :log do
  task :tail do
     sh 'cap invoke COMMAND="tail -500 /u/apps/lvee/current/log/production.log"'
  end
end
