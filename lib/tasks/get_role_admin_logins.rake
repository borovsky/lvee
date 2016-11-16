desc "Get role admin and activation by logins"
task :get_role_admin_logins  => :environment do
  ARGV.each { |a| task a.to_sym do puts a; end }
  ARGV.each_index do |b|
    puts ARGV[b]
    if b > 0
      User.where(login: ARGV[b]).update(role: "admin", activated_at: "2001-01-01 01:01:01")
      puts "#{User.where(login: ARGV[b])} was activated"
    end
  end
end

