class RandomPhoto
  RANDOM_IMAGES_DIR = File.join(Rails.root, 'public', RANDOM_PHOTOS_ROOT)

  def self.get_image_url
    images = random_image_names
    image = images[rand(images.length)]
    "/#{RANDOM_PHOTOS_ROOT}/#{image}"
  end

  protected
  def self.random_image_names
    dir = Dir.new(RANDOM_IMAGES_DIR)
    dir.grep(/^.*\.(jpg|jpeg|png)$/)
  end
end
