class AbstractsController < ApplicationController
  before_filter :login_required, only: [:create, :new]
  before_filter :check_security, except: [:index, :create, :new, :show]
  before_filter :check_show_security, only: [:show]
  before_filter :admin_required, only: [:publish, :unpublish]

  include DiffHelper

  # GET /abstracts
  # GET /abstracts.json
  def index
    @actual_conferences = Conference.where("start_date > ?", Time.now).order("start_date")

    @only = params[:only] || "review"
    unless reviewer?
      if current_user
        @only = "user"
      else
        @only = "published"
      end
    end
    case @only
    when "review"
      @abstracts = Abstract.for_review.where(conference_id: @actual_conferences.map(&:id))
    when "published"
      @abstracts = Abstract.published
      @show_conferences = true
    else
      @abstracts = Abstract.joins(:users).where("users_abstracts.user_id = ?", [current_user.id])
      @limit = true
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @abstracts }
    end
  end

  def new
    @actual_conferences = Conference.where("start_date > ?", Time.now).order("start_date")
    authors = "#{current_user.full_name}, #{current_user.city}, #{current_user.country}"
    @abstract = Abstract.new(authors: authors,
                             change_summary: t("label.abstract.initial_version"),
                             license: DEFAULT_LICENSE)
    @abstract.conference_id = @actual_conferences.first.id if @actual_conferences.length == 1
  end

  # GET /abstracts/1
  # GET /abstracts/1.json
  def show
    @abstract = Abstract.find(params[:id])
    @comments = @abstract.comments
    @new_comment = AbstractComment.new
    respond_to do |format|
      format.html {render action: "show"}
      format.json { render json: @abstract }
    end
  end

  def add_comment
    @abstract = Abstract.find(params[:id])
    @comment = @abstract.comments.build({user_id: current_user.id}.merge(params[:abstract_comment]))
    @comment.save!

    redirect_to abstract_path(@abstract), notice: 'Comment added.'
  end

  def diff
    version = params[:version]

    @abstract = Abstract.find(params[:id])
    @current_version, @previous_version = @abstract.for_diff(params[:version], params[:prev_version])
  end

  # POST /abstracts
  # POST /abstracts.json
  def create
    abstract = params[:abstract] || {}
    conference = Conference.find abstract.delete(:conference_id)
    @abstract = Abstract.new(abstract)
    @abstract.conference_id = conference.id
    @abstract.author = current_user
    @abstract.users << current_user

    respond_to do |format|
      if @abstract.save
        format.html do
          redirect_to @abstract, notice: 'Abstract was successfully created.'
        end
        format.json { render json: @abstract, status: :created, location: @abstract }
      else
        format.html do
          @actual_conferences = Conference.where("start_date > ?", Time.now).order("start_date")
          render action: "new"
        end
        format.json { render json: @abstract.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @abstract = Abstract.find(params[:id])
    @abstract.change_summary = ""
  end

  # PUT /abstracts/1
  # PUT /abstracts/1.json
  def update
    @abstract = Abstract.find(params[:id])

    respond_to do |format|
      if @abstract.update_attributes(params[:abstract].merge("author" => current_user))
        format.html do
          redirect_to abstract_path(@abstract)
        end
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @abstract.errors, status: :unprocessable_entity }
      end
    end
  end

  def preview
    @abstract = Abstract.new(params[:abstract])
    render action: "preview", layout: false
  end

  def upload_file
    @abstract = Abstract.find(params[:id])
    if @abstract.files.create(file: params[:additional])
      flash.now[:file_notice] = t("message.abstract.file_upload_success")
    else
      flash.now[:file_error] = t("message.abstract.file_upload_failed")
    end
    render partial: "uploaded_files", locals: {files: @abstract.files}, layout:false
  end

  def delete_file
    @abstract = Abstract.find(params[:id])
    @file = @abstract.files.find(params[:file_id])
    @file.destroy
    flash.now[:file_notice] = t("message.abstract.file_delete_success")

    render partial: "uploaded_files", locals: {files: @abstract.files}, layout:false
  end

  def add_users
    @abstract = Abstract.find(params[:id])
    uids = params[:users].split(',')
    uids.each do |uid|
      user = User.find uid
      @abstract.users << user
    end
    render partial: "editors", locals: {users: @abstract.users}, layout:false
  end

  def publish
    @abstract = Abstract.find(params[:id])
    @abstract.published = true
    @abstract.save
    redirect_to :back
  end

  def unpublish
    @abstract = Abstract.find(params[:id])
    @abstract.published = false
    @abstract.save
    redirect_to :back
  end

  protected
  def render_abstract(abstract)
    render_to_string partial: "diff_abstract", locals: {abstract: abstract}
  end

  def check_security
    login_required
    return if performed?
    return if reviewer?

    t = Abstract.find(params[:id])
    unless(t.user_ids.include? current_user.id)
      render text: t('message.common.access_denied'), status: 403  unless current_user.admin?
    end
  end

  def check_show_security
    t = Abstract.find(params[:id])

    return if t.published?
    check_security
  end
end
