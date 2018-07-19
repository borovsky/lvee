namespace :get_role do
  desc "Get role admin and activation by first user"
  task :admin  => :environment do
    User.first.update(role: "admin", activated_at: "2001-01-01 01:01:01")
    puts "#{User.first.login} was activated"
  end

  namespace :admin do
    desc "Get role admin and activation by any id"
    task :ids  => :environment do
      ARGV.each_index do |i|
          task ARGV[i].to_sym
          next if i < 1
          User.find(ARGV[i]).update(role: "admin", activated_at: "2001-01-01 01:01:01")
          puts "#{User.find(ARGV[i])} was activated"
        end
    end

    desc "Get role admin and activation by logins"
    task :logins  => :environment do
      ARGV.each_index do |i|
          task ARGV[i].to_sym
          next if i < 1
          User.where(login: ARGV[i]).take.update(role: "admin", activated_at: "2001-01-01 01:01:01")
          puts "#{User.where(login: ARGV[i]).take} was activated"
      end
    end
  end
end

desc "Get role admin and activation by any id"
task :get_role_admin_ids  => :environment do
  ARGV.each { |a| task a.to_sym do puts a; end }
  ARGV.each_index do |b|
    puts ARGV[b]
    if b > 0
      User.find(ARGV[b]).update(role: "admin", activated_at: "2001-01-01 01:01:01")
      puts "#{User.find(ARGV[b])} was activated"
    end
  end
end
