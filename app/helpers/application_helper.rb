# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Displays all flashes if any
  def flashes_if_any
    html = ''
    flash.each do |key,message|
      html << content_tag(:div, message, :id => key)
    end
    html
  end

  # FIXME
  def format_date(time)
    time ? localize(time, :format => :long) : t("date.none")
  end

  def link_to_languages
    html = Language.published.map do |lang|
      img = image_tag("/images/flags/"+lang.name+".png", :alt => lang.description)
      to_params = {:controller => controller.controller_name, :lang => lang.name, :id => params[:id],
        :category => params[:category], :name => params[:name], :action => controller.action_name}
      "<li>" +
        link_to_unless_current( img, to_params) +
        "</li>"
    end
    html.join(' ')
  end

  def article_output(category, name)
    a = Article.load_by_name_or_create(category, name)
    render :partial => "/articles/inline", :locals=> {:article => a}
  end

  def editor?
    current_user && current_user.editor?
  end

  def admin?
    current_user && current_user.admin?
  end

  def article_link(title, category, name)
    link_to(title, :category => category, :name => name, :controller => "articles", :action => 'show')
  end

end
