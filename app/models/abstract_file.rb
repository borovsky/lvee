class AbstractFile < ActiveRecord::Base
  mount_uploader :file, AbstractFilesUploader

  belongs_to :abstract
end
