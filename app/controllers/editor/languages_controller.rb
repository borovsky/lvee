module Editor
  class LanguagesController < ApplicationController
    include LanguageUpdateHelper

    before_filter :editor_required

    active_scaffold :languages do |cfg|
      cfg.columns = [:name, :code3, :description, :published]
      cfg.actions.exclude :create, :show, :search
      cfg.action_links.add(:show, :label => :download, :type => :member, :page => true, :parameters => {:format => :yml})
      cfg.action_links.add(:upload_form, :label => :upload, :type => :member, :parameters => {})
    end


    def show
      def_lang = YAML.load_file("#{LOCALE_DIR}/en.yml")
      cur_f = "#{LOCALE_DIR}/#{params[:id]}.yml"
      cur_lang = YAML.load_file(cur_f) if File.exist?(cur_f)

      hash = def_lang['en']
      hash = hash.deep_merge(cur_lang[params[:id]]) if cur_lang

      txt = hash.ya2yaml

      respond_to do |format|
        format.html {}
        format.yml {render :text => txt}
      end
    end

    def upload_form
      @language = Language.find(params[:id])
    end

    def upload
      @language = Language.find(params[:id])
      unless(params[:language].respond_to? :read)
        flash[:error] = "Please specify file"
        return render :action => "show"
      end

      def_lang = YAML.load_file("#{LOCALE_DIR}/en.yml")
      cur_lang = YAML.load(params[:language].read)
      cur_lang = { params[:id] => cur_lang}

      store_merged_language(def_lang, cur_lang, params[:id])

      redirect_to editor_languages_url
    rescue Exception => e
      flash[:error] = e.message
      render :action => "show"
      logger.error e.message
      logger.error e.backtrace.join("\n")
    end
  end
end
