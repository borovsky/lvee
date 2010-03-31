module Editor
  class ImageUploadsController < ApplicationController
    include ActiveScaffold

    before_filter :editor_required, :scaffold_action
    layout "admin"

    COLUMNS = [:id, :file, :description, :size]
    CREATE_COLUMNS = [:file, :description]
    LIST_COLUMNS = [:description, :file, :size]

    active_scaffold :image_upload do |config|
      cls = Editor::ImageUploadsController
 
      config.file_column_fields
      config.columns = cls::COLUMNS
      config.create.columns = cls::CREATE_COLUMNS
      config.list.per_page = 100
    end
  end
end
