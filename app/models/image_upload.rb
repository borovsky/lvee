require 'RMagick'

class ImageUpload < ActiveRecord::Base
  file_column :file, :magick => {:transform => Proc.new {|i|}}

  def before_validation_on_create
    if file
      p file
      imgs = Magick::Image.read(file)
      if(imgs.length > 0)
        img = imgs.first
        self.width = img.columns
        self.height = img.rows
      end
    end
  end

  def file_path
    return "#{BASE_UPLOAD_PATH}/#{id}.#{ext}"
  end

  def size
    "#{width}x#{height}"
  end

  def do_nothing
  end
end
