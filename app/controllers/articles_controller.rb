class ArticlesController < ApplicationController
  before_filter :editor_required, :except => [:show]

  before_filter :load_article_by_category, :except => [:index, :create, :translate, :diff]

  include DiffHelper

  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.translated

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article ||= Article.find(params[:id])
    @title = @article.title

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article ||= Article.new(:locale => I18n.default_locale)
    @title = t('label.article.creating')

    respond_to do |format|
      format.html { render :action => "new" }
      format.xml  { render :xml => @article }
    end
  end

  def translate
    article = Article.find(params[:id])
    @article = Article.new(article.attributes.merge(:locale => params[:lang], :id => nil))
    @title = t('label.article.creating')

    self.new
  end

  # GET /articles/1/edit
  def edit
    @article ||= Article.find(params[:id])
    @title = t('label.article.editing')
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])
    @article.user_id = current_user.id
    @title = t('label.article.creating')

    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to(article_path(:id =>@article.id)) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article ||= Article.find(params[:id])
    @article.user_id = current_user.id
    @title = t('label.article.creating')

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to(article_path(:id=>@article.id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article ||= Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end

  def preview
    @article = Article.new(params[:article])
    render :action => "preview", :layout => false
  end

  def diff
    version = params[:version]
    @article = Article.find(params[:id])

    if(version)
      @article = @article.find_version(version)
    else
      @article = @article.versions.latest
    end

    @prev = params[:prev_version] ? Article.find_version(@article.article_id, params[:prev_version]) : @article.previous
  end

  protected
  def render_article(article)
    render_to_string :partial=> "/articles/article", :locals => {:article => article}
  end

  def load_article_by_category
    if(params[:id])
      @article = Article.find_by_id(params[:id])
      if(@article)
        params[:category] = @article.category
        params[:name] = @article.name
        params[:id] = nil
      end
    elsif (editor?)
      @article = Article.load_by_name_or_create(params[:category], params[:name])
    else
      @article = Article.load_by_name(params[:category], params[:name])
    end
  end
end
