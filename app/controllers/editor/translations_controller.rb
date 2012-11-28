class Editor::TranslationsController < ApplicationController
  layout :check_layout

  # GET /editor/translations
  # GET /editor/translations.json
  def index
    @translations = Translation.for_locale(I18n.locale).as_hash
    @original_translations = Translation.for_locale(I18n.default_locale).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @translations }
    end
  end

  # GET /editor/translations/1
  # GET /editor/translations/1.json
  def show
    @translation = Translation.find(params[:id])

    respond_to do |format|
      format.json { render json: @translation }
    end
  end

  # GET /editor/translations/new
  # GET /editor/translations/new.json
  def new
    @translation = Translation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @translation }
    end
  end

  # GET /editor/translations/1/edit
  def edit
    @translation = Translation.find(params[:id])
    base = @translation
    if(@translation.language_id.to_s != I18n.locale.to_s)
      @translation = Translation.new
      @translation.language_id = I18n.locale
      @translation.key = base.key
      @translation.value = base.value
      @translation.pluralization_index = base.pluralization_index
    end
  end

  # POST /editor/translations
  # POST /editor/translations.json
  def create
    @translation = Translation.new
    t = params[:translation]
    @translation.key = t[:key]
    @translation.value =  t[:value]
    @translation.pluralization_index =  t[:pluralization_index]
    @translation.language_id =  t[:language_id]

    respond_to do |format|
      if @translation.save
        format.html { redirect_to editor_translations_path, notice: 'Translation was successfully created.' }
        format.json { render json: @translation, status: :created, location: @translation }
      else
        format.html { render action: "new" }
        format.json { render json: @translation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /editor/translations/1
  # PUT /editor/translations/1.json
  def update
    @translation = Translation.find(params[:id])

    respond_to do |format|
      if @translation.update_attributes(params[:translation])
        format.html { redirect_to editor_translations_path, notice: 'Translation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @translation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /editor/translations/1
  # DELETE /editor/translations/1.json
  def destroy
    @translation = Translation.find(params[:id])
    @translation.destroy

    respond_to do |format|
      format.html { redirect_to editor_translations_url }
      format.json { head :no_content }
    end
  end

  def check_layout
    request.xhr? ? false : "admin"
  end
end
