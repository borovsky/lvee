require 'fileutils'

BACKUP_DIR = File.join(Rails.root, "..", "file_backup")

def to_new_path(i)
  a = []
  while i > 0
    a << i%10000
    i /= 10000
  end
  a << 0 if a.length < 2

  File.join(*(a.reverse.map{|i| "%04d" % i}))
end

def reorganize_files_in(dir)
  backup_dir = File.join(BACKUP_DIR, dir)
  base = File.join(Rails.root, "public", dir)
  puts "Processing #{dir}..."
  puts "  Backing up to #{backup_dir}"
  FileUtils.mkdir_p(backup_dir)
  FileUtils.copy_entry(base, backup_dir, true, true, true)

  puts "  Reorganizing..."
  FileUtils.rm_rf(base)
  Dir.new(backup_dir).grep(/\d+/).each{|i|
    from = File.join(backup_dir, i)
    to = File.join(base, to_new_path(i.to_i))

    puts "    #{from} => #{to}"
    FileUtils.mkdir_p to
    FileUtils.copy_entry(from, to, true, true, true)
  }
end

desc "Reorganize files to new file_column directory schema"
task :reorganize_files do
  FileUtils.rm_rf(BACKUP_DIR)
  dirs = [
    "image_upload/file",
    "sponsor/image",
    "user/avator",
  ]
  dirs.each {|d| reorganize_files_in(d)}
end

