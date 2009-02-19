# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Displays all flashes if any
  def flashes_if_any
    html = ''
    flash.each do |key,message|
      html << content_tag(:div, message, :id => key)
      html << content_tag(:script, :type => "text/javascript") do
        "new Effect.Pulsate('#{key.to_s}');new Effect.Fade('#{key.to_s}', { delay: 120 } );"
      end
    end
    html
  end

  # FIXME
  def format_date(time)
    time ? localize(time, :format => :long) : t("date.none")
  end

  def menu_item(text, url_opts, &block)
    current = false
    if url_opts[:action]
      current = controller.action_name == url_opts[:action]
    else
      current = controller.controller_name == url_opts[:controller]
    end
    url = url_for(url_opts)

    menu_html = "<li#{current ? ' class="menu-place"' : ''}><a href=\"#{url}\">#{text}</a>"
    menu_html << capture(&block) if current && block_given?
    menu_html << "</li>"

    concat(menu_html) if block_given?

    menu_html
  end

  def sub_menu_item(text, url_opts)
    current = false
    if url_opts[:action]
      current = controller.action_name == url_opts[:action]
    else
      current = controller.controller_name == url_opts[:controller]
    end
    url       = url_for(url_opts)
    menu_html = "<a href=\"#{url}\" #{current ? ' class="menu-place"' : ''}>#{text}</a>"
  end

  def links_to_languages()
    langs = Language.published.map{|l| l.name}
    html = langs.map do |lang|
      if controller.action_name
        link_to_unless_current( lang, :controller => controller.controller_name, :action => controller.action_name, :lang => lang, :id => params[:id])
      else
        link_to_unless_current( lang, :controller => controller.controller_name, :lang => lang, :id => params[:id])
      end
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
end
