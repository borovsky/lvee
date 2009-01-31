module Editor
  class LanguagesController < ApplicationController
    before_filter :editor_required
    # GET /languages
    # GET /languages.xml
    def index
      @languages = Language.find(:all)

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
      cur_lang = YAML.load_file("#{LOCALE_DIR}/#{params[:id]}.yml")

      hash = def_lang['en'].deep_merge(cur_lang[params[:id]])

      txt = hash.ya2yaml

      respond_to do |format|
        format.html {}
        format.yml {render :text => txt}
      end
    end

    def upload
      def_lang = YAML.load_file("#{LOCALE_DIR}/en.yml")
      cur_lang = YAML.load(params[:language].read)

      hash = def_lang['en'].deep_merge(cur_lang)
      new_hash = {params[:id] => hash}
      File.open("#{LOCALE_DIR}/#{params[:id]}.yml", "w") do |f|
        f.write(new_hash.ya2yaml)
      end
      redirect_to :action => 'show', :language => params[:id]
    end
  end
end
