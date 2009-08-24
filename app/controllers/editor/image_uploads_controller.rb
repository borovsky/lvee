module Editor
  class ImageUploadsController < ApplicationController
    include ActiveScaffold

    before_filter :editor_required, :scaffold_action
    layout "admin"

    COLUMNS = [:id, :file, :description, :size]
    CREATE_COLUMNS = [:file, :description]
    LIST_COLUMNS = [:description, :file, :size]

    active_scaffold :image_upload do
      cls = Editor::ImageUploadsController
      self.file_column_fields = :file
      self.columns = cls::COLUMNS
      self.create.columns = cls::CREATE_COLUMNS
      self.list.per_page = 100
    end
  end
end
