module Editor
  class MetainfosController < ApplicationController
    before_filter :editor_required
    layout "admin"

    COLUMNS = [:language, :page, :keywords, :description]

    active_scaffold :metainfo do |config|
      cls = Editor::MetainfosController

      config.actions = [:list, :update, :show, :delete, :search]
      config.columns = cls::COLUMNS
      config.columns[:language].form_ui = :static
      config.columns[:page].form_ui = :static
      config.list.per_page = 100
    end

    def change
      m = Metainfo.new(params[:metainfo])

      if m2 = Metainfo.find_by_page_and_language(m.page, m.language)
        m2.update_attributes!(params[:metainfo])
      else
        m.save!
      end
      unless(Metainfo.find_by_page_and_language(m.page, I18n.default_locale))
        m_def = Metainfo.new(params[:metainfo])
        m_def.language = I18n.default_locale
        m_def.save!
      end
    end

  end

end
