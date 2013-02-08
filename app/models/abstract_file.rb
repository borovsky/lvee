class AbstractFile < ActiveRecord::Base
  mount_uploader :file, AbstractFilesUploader

  belongs_to :abstract
  attr_accessible :file

  validates :file, presence: true
end
