module Editor
  class LanguagesController < ApplicationController
    include LanguageUpdateHelper

    before_filter :editor_required

    active_scaffold :language do |cfg|
      cfg.columns = [:name, :code3, :description, :published]
      cfg.actions.exclude :show, :search
    end
  end
end
