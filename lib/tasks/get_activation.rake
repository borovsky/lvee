desc "Get activation by first user"
  task :activation  => :environment do
    User.first.update(activated_at: "2001-01-01 01:01:01")
    puts "#{User.first.login} was activated"
end

desc "Get activation by all users"
  task :activation_all  => :environment do
    User.all.update_all(activated_at: "2001-01-01 01:01:01")
    puts "All users were activated"
end
