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

end
