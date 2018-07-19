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
	  m = Metainfo.where(params[:metainfo]).new
	  m2 = Metainfo.where("page = ? AND language = ?", m.page, m.language).take
	  unless m2.nil?
	    m2.update(params[:metainfo])
	  else
	    m.save!
	  end
	  unless(Metainfo.where("page = ? AND language = ?", m.page, I18n.default_locale).any?)
	    m_def = Metainfo.where(params[:metainfo]).new
	    m_def.language = I18n.default_locale
	    m_def.save!
	  end
	    render plain: "Ok"
    end
  end
end
