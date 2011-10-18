class ThesisesController < ApplicationController
  before_filter :login_required, :only => [:index, :create]
  before_filter :check_security, :except => [:index, :create]
  include DiffHelper

  # GET /thesises
  # GET /thesises.json
  def index
    @actual_conferences = Conference.where("start_date < ?", Time.now).order("start_date")
    if current_user.reviewer? && !(params[:only] == 'user')
      @thesises = Thesis.for_review.where(:conference_id => @actual_conferences.map(&:id))
      @limit = false
    else
      @thesises = Thesis.joins(:users).where("users_thesises.user_id", current_user.id)
      @limit = true
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @thesises }
    end
  end

  def new
    @actual_conferences = Conference.where("start_date > ?", Time.now).order("start_date")
    @thesis = Thesis.new(:authors => "#{current_user.full_name}, #{current_user.city}, #{current_user.country}")
    @thesis.conference_id = @actual_conferences.first.id if @actual_conferences.length == 1
  end

  # GET /thesises/1
  # GET /thesises/1.json
  def show
    @thesis = Thesis.find(params[:id])
    @comments = @thesis.comments
    @new_comment = ThesisComment.new
    respond_to do |format|
      format.html {render :action => "show"}
      format.json { render json: @thesis }
    end
  end

  def add_comment
    @thesis = Thesis.find(params[:id])
    @comment = @thesis.comments.build({:user_id => current_user.id}.merge(params[:thesis_comment]))
    @comment.save!
    
    redirect_to thesis_path(@thesis), notice: 'Comment added.'
  end

  def diff
    version = params[:version]

    @thesis = Thesis.find(params[:id])
    @current_version, @previous_version = @thesis.for_diff(params[:version], params[:prev_version])
  end

  # POST /thesises
  # POST /thesises.json
  def create
    @thesis = Thesis.new(params[:thesis])
    @thesis.conference_id = params[:thesis][:conference_id]
    @thesis.author = current_user
    @thesis.users << current_user
    
    respond_to do |format|
      if @thesis.save
        format.html do
          redirect_to @thesis, notice: 'Thesis was successfully created.'
        end
        format.json { render json: @thesis, status: :created, location: @thesis }
      else
        format.html do
          @actual_conferences = Conference.where("start_date > ?", Time.now).order("start_date")
          render action: "new"
        end
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
          redirect_to thesis_path(@thesis)
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

  def check_security
    return if(reviewer?)
    return if performed?
    t = Thesis.find(params[:id])
    unless(t.user_ids.include? current_user.id)
      render :text=>t('message.common.access_denied'), :status=>403  unless current_user.admin?
    end
  end
end
