module ConferenceRegistrationsHelper

  URL_REGEXP = %r|(.*?://)([^/]+)(/.*)?| #/

  def strip_urls str
    out = []
    return str if str.blank?

    str.split(' ').each do |word|
      if word =~ URL_REGEXP
        out << word.gsub(URL_REGEXP) { "<a class=\"participants_url\" href=\"#{word}\" title=\"#{word}\">#{$1}#{$2}</a>" }
      else
        out << word
      end
    end

    out.join(' ')
  end

#  def as_(param, opts={})
#    t("label.conference_registration.#{param}", :default => t("label.common.#{param}"))
#  end

  def transport_options(type)
    values = TRANSPORT.map do |i|
      [t("label.conference_registration.transport_#{type}_list.#{i}"), i]
    end
    values = [[t("label.common._select_"), ""]] + values
  end

  def floor_form_column(record, input_name)
    content_tag("div", check_box("record", "floor"))
  end

  def days_form_column(record, input_name)
    translated_days = I18n.translate(:'date.day_names')
    end_days = I18n.translate(:'date.day_names', :locale => I18n.default_locale)
    days = translated_days.zip(end_days)
    selectable_days = days[4..-1] + [days[0]]
    selected_days = @record.days

    days_list = selectable_days.map do |day|
      content_tag(:li,  check_box_tag("record[days][]", day[1], selected_days.include?(day[1]))+  h(day[0]))
    end
    content_tag(:div, content_tag(:ul, days_list.join("\n").html_safe) +
      hidden_field_tag("record[days][]", ""))
  end

  def tshirt_form_column(record, input_name)
    s = ""
    selected_sizes = @record.tshirt
    @record.quantity.times do|i|
      s << select_tag("record[tshirt][]", options_for_select(TSHIRT_SIZES, selected_sizes[i]))
    end
    content_tag(:div, s.html_safe)
  end

  def transport_from_form_column(record, input_name)
    select("record", "transport_from",  transport_options(:from))
  end

  def transport_to_form_column(record, input_name)
    select("record", "transport_to",  transport_options(:to))
  end

end
