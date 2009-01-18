desc "Run specs and rcov"
Spec::Rake::SpecTask.new(:specs_rcov) do |t|
  t.spec_opts = ['--options', "#{RAILS_ROOT}/spec/spec_rcov.opts"]
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', '/usr/share/ruby,/home/alex/.gem,/usr/lib/ruby', '--rails', '--text-report']
end
