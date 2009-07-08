class WikiPagesController < ApplicationController
  before_filter :login_required, :except => [:show]
  before_filter :load_wiki_page_by_name

  include DiffHelper

  def index
    @wiki_pages = WikiPage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wiki_pages }
    end
  end

  def show
    @title = @wiki_page.name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wiki_page }
    end
  end

  def new
    @wiki_page = WikiPage.new
    @title = t('label.wiki_page.creating')

    respond_to do |format|
      format.html { render :action => "new" }
      format.xml  { render :xml => @wiki_page }
    end
  end

  def edit
    @title = t('label.wiki_page.editing')
  end

  def create
    @wiki_page = WikiPage.new(params[:wiki_page])
    @wiki_page.user_id = current_user.id
    @title = t('label.wiki_page.creating')

    respond_to do |format|
      if @wiki_page.save
        flash[:notice] = 'WikiPage was successfully created.'
        format.html { redirect_to(wiki_page_path(:id =>@wiki_page.name)) }
        format.xml  { render :xml => @wiki_page, :status => :created, :location => @wiki_page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wiki_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @wiki_page.user_id = current_user.id
    @title = t('label.wiki_page.creating')

    respond_to do |format|
      begin
        if @wiki_page.update_attributes(params[:wiki_page])
          flash[:notice] = 'WikiPage was successfully updated.'
          format.html { redirect_to(wiki_page_path(:id=>@wiki_page.name)) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @wiki_page.errors, :status => :unprocessable_entity }
        end
      rescue ActiveRecord::StaleObjectError => e
        flash[:error] = "WikiPage modified by other user. Please return to previous page, reload it and apply your changes."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wiki_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def preview
    @wiki_page = WikiPage.new(params[:wiki_page])
    render :action => "preview", :layout => false
  end

  def diff
    version = params[:version]

    if(version)
      @wiki_page = @wiki_page.find_version(version)
    else
      @wiki_page = @wiki_page.versions.latest
    end

    @prev = params[:prev_version] ? WikiPage.find_version(@wiki_page.wiki_page_id, params[:prev_version]) : @wiki_page.previous
  end

  protected
  def render_wiki_page(page)
    render_to_string :partial=> "/wiki_pages/diff_wiki_page", :locals => {:wiki_page => page}
  end

  def load_wiki_page_by_name
    if params[:id]
      @wiki_page = WikiPage.find_by_name(params[:id])
      @wiki_page ||= WikiPage.find(params[:id])
    end
  end
end
