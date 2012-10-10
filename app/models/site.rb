require 'zip/zip'
require 'fileutils'

class Site < ActiveRecord::Base
  mount_uploader :file, SiteUploader

  attr_accessible :default, :file, :name

  validate :check_archive
  validates :name, :file, presence: true
  after_save :unpack_archive

  after_destroy :cleanup_archive

  scope :default, where(default: true)

  def file_path(name)
    File.join(dir, name)
  end

  def file_url(name)
    "/" + [url_root, name].join('/')
  end

  protected

  def check_archive
    self.stylesheet = false
    self.javascript = false
    Zip::ZipFile.foreach(file.path) do |e|
      self.stylesheet = true if e.name == 'style.css'
      self.javascript = true if e.name == 'script.js'
    end
  rescue Exception
    errors.add(:file, :'should_be_zip')
  end

  def unpack_archive
    cleanup_archive
    FileUtils.mkdir_p dir
    Zip::ZipFile.foreach(file.path) do |e|
      e.extract(file_path(e.name))
    end
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
