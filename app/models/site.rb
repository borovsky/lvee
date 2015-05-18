require 'zip'
require 'fileutils'
require 'png_checker'

class Site < ActiveRecord::Base
  mount_uploader :file, SiteUploader

  attr_accessible :default, :file, :name

  validate :check_archive
  validates :name, presence: true
  after_save :unpack_archive

  after_destroy :cleanup_archive

  scope :default, where(default: true)

  def file_path(name)
    File.join(dir, name)
  end

  def file_path_if_exists(name)
    path = file_path(name)
    File.exists?(path) ? path : nil
  end

  def file_url(name)
    "/" + [url_root, name].join('/')
  end

  def unpack_archive
    cleanup_archive
    FileUtils.mkdir_p dir
    Zip::File.foreach(file.path) do |e|
      e.extract(file_path(e.name))
    end
  end

  protected

  def check_archive
    self.stylesheet = false
    self.javascript = false
    Zip::File.foreach(file.path) do |e|
      self.stylesheet = true if e.name == 'style.css'
      self.javascript = true if e.name == 'script.js'
      if e.name =~ /^badges\/.*\.png$/
        begin
          e.get_input_stream do |f|
            PngChecker.check_png(f, e.name)
          end
        rescue
          puts $!, $!.backtrace
          errors.add(:file, $!.message)
        end
      end
    end
  rescue Exception
    errors.add(:file, :'should_be_zip')
  end

  def cleanup_archive
    FileUtils.rm_rf dir
  end

  def url_root
    @url_root ||= ['sites', self.id.to_s].join('/')
  end

  def dir
    @dir ||= File.join(Rails.public_path, 'sites', self.id.to_s)
  end
end
