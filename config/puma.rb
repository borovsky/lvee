environment ENV['RACK_ENV'] || 'production'

app_dir = File.expand_path("../..", __FILE__)
tmp_dir = "#{app_dir}/tmp"

workers 1
threads 0, 8

# Set up socket location
bind "unix://#{tmp_dir}/sockets/puma.sock"

# Logging
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{tmp_dir}/pids/puma.pid"
state_path "#{tmp_dir}/pids/puma.state"
