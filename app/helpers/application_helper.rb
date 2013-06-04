module ApplicationHelper
  include MenuHelper

  def my_encode_ascii content
    array_utf8 = content.unpack('U*')
    array_enc = []
    array_utf8.each do |num|
      if num <= 0x7F
        array_enc << num
      else
        # Numeric entity (&#nnnn;); shard by  Stefan Scholl
        array_enc.concat "&\##{num};".unpack('C*')
      end
      end
    array_enc.pack('C*')
  end

  def active_scaffold_input_static(column, html_options)
    @record.send(column.name) if @record
  end

  protected

  def render_statistics
    @users ||= User.includes(:conference_registrations)
    @conferences ||= Conference.all

    @statistics ||= ConferenceStatisticsPresenter.new(@users, @conferences)

    render "/admin/shared/statistics"
  end

  def cache_with_timeout(key, timeout, &block)
    key ||= request.path
    result = controller.cache_result_for(key, timeout) do
      capture(&block)
    end
    concat(result)
  end

  # Displays all flashes if any
  def flashes_if_any
    html = ''
    [:notice, :error].each do |key|
      message = flash[key]
      html << content_tag(:p, message, :class => key) if(message)
    end
    flash.discard
    html.html_safe
  end

  def page_title
    if @title.blank?
      'LVEE'
    else
      h("#{@title} - LVEE")
    end
  end

  def format_date(time)
    time ? localize(time, :format => :long) : t("date.none")
  end

  def link_to_languages
    html = Language.published.map do |lang|
      img = lang.code3.upcase
      to_params = params_to_lang(lang.name)
      "<li>" +
        link_to_unless_current( img, to_params) +
        "</li>"
    end
    html.join(' ').html_safe
  end

  def article_output(category, name)
    a = Article.load_by_name_or_create(category, name)
    render "/articles/inline", :article => a
  end

  def editor?
    current_user.try(:editor?)
  end

  def admin?
    current_user.try(:admin?)
  end

  def reviewer?
    current_user.try(:reviewer?)
  end

  def w3c_date(date)
    date.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end

  def params_to_lang(lang)
    {:controller => controller.controller_name, :lang => lang, :id => params[:id],
      :user_id => params[:user_id], :conference_id => params[:conference_id],
      :category => params[:category], :name => params[:name], :action => controller.action_name}
  end

  def textilize_with_latex(text, *options)
    text = text.gsub(/\\\$\$/, "<double-d>").gsub(/\\\$/, "<single-d>")
    t2 = text.gsub(/\$\$([^$]+)\$\$/m) do |m|
      f = $1.strip
      "\ndiv. !#{LATEX_WS_BASE}\\displaystyle%20#{URI.escape(f)}!\n"
    end
    t3 = t2.gsub(/\$([^$]+)\$/m) do |m|
      f = $1.strip
      "!#{LATEX_WS_BASE}\\textstyle%20#{URI.escape(f)}!"
    end
    t4 = t3.gsub("<double-d>", "$$").gsub("<single-d>", "$")
    content_tag(:div, textilize(t4), class: 'textile')
  end

  #FIXME: Move to separate helper
  def textilize(text, *options)
    options ||= [:hard_breaks]

    if text.blank?
      ""
    else
      textilized = ::RedCloth.new(text, options)
      textilized.to_html.html_safe
    end
  end

  def textilize_without_paragraph(text)
    textiled = textilize(text)
    if textiled[0..2] == "<p>" then textiled = textiled[3..-1] end
    if textiled[-4..-1] == "</p>" then textiled = textiled[0..-5] end
    return textiled.html_safe
  end

  def logged_in?
    controller.logged_in?
  end
end
