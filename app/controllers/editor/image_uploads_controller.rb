module Editor
  class ImageUploadsController < ApplicationController
    before_filter :editor_required, :scaffold_action
    layout "admin"
    
    COLUMNS = [:id, :file, :description, :size]
    CREATE_COLUMNS = [:file, :description]
    LIST_COLUMNS = [:description, :file, :size]

    active_scaffold :image_upload do |config|
      config.file_column_fields = :file
      config.columns = COLUMNS
      config.create.columns = CREATE_COLUMNS
    end
  end
end
