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

  def sexy_time_format(time)
    time.strftime('%d.%m.%Y')
  end

  def main_menu_item(text, args, submenu = '')
    css_class = controller.controller_name == args[:controller] ? ' class="menu-place"' : ''
    menu_html = "<li#{css_class}><a href=\"#{args[:link] || ('/' + args[:controller])}\">#{text}</a>"
    menu_html << "<ul class=\"sub-menu\">#{submenu}</ul>" unless submenu.empty?
    menu_html << "</li>"
    menu_html
  end

end
