class ThesisesController < ApplicationController
  include DiffHelper

  # GET /thesises
  # GET /thesises.json
  def index
    @thesises = Thesis.for_review

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @thesises }
    end
  end

  # GET /thesises/1
  # GET /thesises/1.json
  def show
    if params[:user_id]
      @thesis = Thesis.find_by_conference_registration_id(params[:id])
      unless @thesis
        @thesis = Thesis.new
        @thesis.conference_registration_id = params[:id]
      end
    else
      @thesis = Thesis.find(params[:id])
    end
    @comments = @thesis.comments
    @new_comment = ThesisComment.new
    respond_to do |format|
      format.html do
        if @thesis.new_record?
          render :action => "new"
        else
          render :action => "show"
        end
      end
      format.json { render json: @thesis }
    end
  end

  def add_comment
    if params[:user_id]
      @thesis = Thesis.find_by_conference_registration_id(params[:id])
      raise RecordNotFound, "Couldn't find thesises" unless @thesis
    else
      @thesis = Thesis.find(params[:id])
    end
    @comment = @thesis.comments.build({:user_id => current_user.id}.merge(params[:thesis_comment]))
    @comment.save!
    
    if(@thesis.conference_registration.user_id == current_user.id)
      redirect_to user_thesises_path(current_user.id, @thesis.conference_registration_id), notice: 'Comment added.'
    else
      redirect_to thesis_path(@thesis), notice: 'Comment added.'
    end
  end

  def diff
    version = params[:version]

    if params[:user_id]
      @thesis = Thesis.find_by_conference_registration_id(params[:id])
      raise RecordNotFound, "Couldn't find thesises" unless @thesis
    else
      @thesis = Thesis.find(params[:id])
    end

    @current_version, @previous_version = @thesis.for_diff(params[:version], params[:prev_version])
  end

  # POST /thesises
  # POST /thesises.json
  def create
    @thesis = Thesis.new(params[:thesis])
    @thesis.conference_registration_id = params[:thesis][:conference_registration_id]
    @thesis.author = current_user

    respond_to do |format|
      if @thesis.save
        format.html do
          redirect_to user_thesises_path(@thesis.user_id, @thesis.conference_registration_id), notice: 'Thesis was successfully created.'
        end
        format.json { render json: @thesis, status: :created, location: @thesis }
      else
        format.html { render action: "new" }
        format.json { render json: @thesis.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    if params[:user_id]
      @thesis = Thesis.find_by_conference_registration_id(params[:id])
      raise RecordNotFound, "Couldn't find thesises" unless @thesis
    else
      @thesis = Thesis.find(params[:id])
    end
    @thesis.change_summary = ""
  end

  # PUT /thesises/1
  # PUT /thesises/1.json
  def update
    @thesis = Thesis.find(params[:id])

    respond_to do |format|
      if @thesis.update_attributes(params[:thesis].merge("author" => current_user))
        format.html do
          if(@thesis.conference_registration.user_id == current_user.id)
            redirect_to user_thesises_path(current_user.id, @thesis.conference_registration_id), notice: 'Thesis was successfully updated.'
          else
            redirect_to thesis_path(@thesis)
          end
        end
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @thesis.errors, status: :unprocessable_entity }
      end
    end
  end

  def preview
    @thesis = Thesis.new(params[:thesis])
    render :action => "preview", :layout => false
  end

  protected
  def render_article(article)
    render_to_string :partial=> "/articles/diff_article", :locals => {:article => article}
  end
end
