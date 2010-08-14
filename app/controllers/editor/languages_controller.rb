module Editor
  class LanguagesController < ApplicationController
    include LanguageUpdateHelper

    before_filter :editor_required
    # GET /languages
    # GET /languages.xml
    def index
      @languages = Language.all

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @languages }
      end
    end

    # GET /languages/1
    # GET /languages/1.xml
    def show
      @language = Language.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @language }
      end
    end

    # GET /languages/new
    # GET /languages/new.xml
    def new
      @language = Language.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @language }
      end
    end

    # GET /languages/1/edit
    def edit
      @language = Language.find(params[:id])
    end

    # POST /languages
    # POST /languages.xml
    def create
      @language = Language.new(params[:language])
      @language.name = params[:language][:name]  if params[:language]

      respond_to do |format|
        if @language.save
          flash[:notice] = translate('message.language.created')
          format.html { redirect_to(editor_language_path(:id => @language)) }
          format.xml  { render :xml => @language, :status => :created, :location => editor_language_path(:id =>@language) }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @language.errors, :status => :unprocessable_entity }
        end
      end
    end

    # PUT /languages/1
    # PUT /languages/1.xml
    def update
      @language = Language.find(params[:id])
      @language.name = params[:language][:name] if params[:language]

      respond_to do |format|
        if @language.update_attributes(params[:language])
          flash[:notice] = translate('message.language.updated')
          format.html { redirect_to(editor_language_path(:id =>@language)) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @language.errors, :status => :unprocessable_entity }
        end
      end
    end

    # DELETE /languages/1
    # DELETE /languages/1.xml
    def destroy
      @language = Language.find(params[:id])
      @language.destroy

      respond_to do |format|
        format.html { redirect_to(editor_languages_url) }
        format.xml  { head :ok }
      end
    end

    def download
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

      redirect_to editor_language_url(:id => params[:id])
    rescue Exception => e
      flash[:error] = e.message
      render :action => "show"
      logger.error e.message
      logger.error e.backtrace.join("\n")
    end
  end
end
