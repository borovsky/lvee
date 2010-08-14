require 'RMagick'

class ImageUpload < ActiveRecord::Base
  file_column :file

  before_validation :method => :set_image_size

  def set_image_size
    if file
      imgs = Magick::Image.read(file)
      if(imgs.length > 0)
        img = imgs.first
        self.width = img.columns
        self.height = img.rows
      end
    end
  end

  def size
    "#{width}x#{height}"
  end

  def do_nothing
  end
end
