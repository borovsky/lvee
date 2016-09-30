desc "Get role admin and activation by first user"
task :get_role_admin  => :environment do
  User.first.update(role: "admin", activated_at: "2001-01-01 01:01:01")
  puts "#{User.first.login} was activated"
end
