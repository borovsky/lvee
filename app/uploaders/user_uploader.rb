# encoding: utf-8

class UserUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader
  storage :file
  #     storage :s3

  # Override the directory where uploaded files will be stored
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded
  #     def default_url
  #       "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  #     end

  # Process files as they are uploaded.
  process :process_image => AVATAR_SIZE
  #
  #     def scale(width, height)
  #       # do something
  #     end

  def process_image(width, height)
    manipulate! do |img|
      if original_filename && original_filename =~ /\.bmp$/
        img.format "jpg"
      end
      img.resize("#{width}x#{height}")
      img
    end
  end

  # Create different versions of your uploaded files
  version :list do
    process :process_image => LIST_AVATAR_SIZE
  end

  # Add a white list of extensions which are allowed to be uploaded,
  # for images you might use something like this:
  #def extension_white_list
  #  %w(jpg jpeg gif png)
  #end


  # Override the filename of the uploaded files
  def filename
    f = original_filename
    if f && f =~ /\.bmp$/
      File.basename(f, File.extname(f)) + '.jpg'
    else
      f
    end
  end

end
