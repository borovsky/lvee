class NewsController < ApplicationController
  before_filter :admin_required, :only => [:publish_now]
  before_filter :editor_required, :except => [:index, :show, :rss]
  # GET /news
  # GET /news.xml
  def index
    if(current_user && current_user.editor?)
      @news = News.translated
    else
      @news = News.published.translated
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @news }
    end
  end

  # GET /news/1
  # GET /news/1.xml
  def show
    @news = News.find(params[:id]).translation

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @news }
    end
  end

  def publish
    @news = News.find(params[:id])
    @news = News.find(@news.parent_id) if(@news.parent_id)
    @news.publish
    redirect_to news_item_url(:id => @news.id)
  end

  def publish_now
    @news = News.find(params[:id])
    @news = News.find(@news.parent_id) if(@news.parent_id)
    @news.publish_now
    redirect_to news_item_url(:id => @news.id)
  end

  # GET /news/new
  # GET /news/new.xml
  def new
    @news = News.new
    @news.locale = params[:locale] || I18n.default_locale
    if(params[:parent_id])
      @news.parent_id = params[:parent_id]
      parent = News.find(params[:parent_id])
      @news.title = parent.title
      @news.lead = parent.lead
      @news.body = parent.body
    end


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @news }
    end
  end

  # GET /news/1/edit
  def edit
    @news = News.find(params[:id])
  end

  # POST /news
  # POST /news.xml
  def create

    @news = News.new(params[:news])
    @news.user = current_user

    respond_to do |format|
      if @news.save
        flash[:notice] = t('message.news.created')
        format.html { redirect_to(:action => 'show', :id => @news) }
        format.xml  { render :xml => @news, :status => :created, :location => @news }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @news.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /news/1
  # PUT /news/1.xml
  def update
    @news = News.find(params[:id])

    respond_to do |format|
      if @news.update_attributes(params[:news])
        flash[:notice] = t('message.news.updated')
        format.html { redirect_to(news_item_path(:id=>@news)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @news.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1
  # DELETE /news/1.xml
  def destroy
    @news = News.find(params[:id])
    @news.destroy

    respond_to do |format|
      format.html { redirect_to(news_url) }
      format.xml  { head :ok }
    end
  end

  def preview
    @news = News.new(params[:news])
    render :action => "preview", :layout => false
  end

  def rss
    @news = News.published.translated
    render :action => 'rss', :layout => false
  end
end
