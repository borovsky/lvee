class ImageUpload < ActiveRecord::Base
  mount_uploader :file, ImageUploader

  before_validation :method => :set_image_size

  def set_image_size
    if self.image.current_path
      imgs = ImageMagick::Image.read(self.image.current_path)
      if(imgs.length > 0)
        img = imgs.first
        self.width = img.columns
        self.height = img.rows
      end
      imgs.each{|i| i.destroy!}
    end
  end

  def size
    "#{width}x#{height}"
  end

  def do_nothing
  end
end
