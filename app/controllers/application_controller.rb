# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  clear_helpers

  rescue_from ::AbstractController::ActionNotFound,
  ::ActiveRecord::RecordNotFound, :with => :not_found_error_handler

  include AuthenticatedSystem

  before_filter :language_select
  before_filter :metainfo_load
  before_filter :site_select

  protect_from_forgery # :secret => 'dc50c44338f5eba496ede18e9ea29cb1'


  def cache_result_for(key, timeout, &block)
    key = fragment_cache_key(key)
    f = read_fragment(key)
    fragment = f ? Marshal::load(f) : nil

    if(fragment.kind_of?(Array) and
          fragment.length == 2 and
          fragment.first > timeout.ago)
      return fragment.second
    end
    result = yield
    r = [Time.now, result]
    write_fragment(key, Marshal.dump(r))
    result
  end

  protected
  def language_select()
    lang = params[:lang] || session[:lang]

    if(LANGUAGE_MAP[lang])
      return redirect_to(params_to_lang(LANGUAGE_MAP[lang]))
    end

    unless lang.blank?
      unless(I18n.available_locales.find{|l| l.to_s == lang})
        session[:lang] = nil
        return redirect_to("/")
      end
    end

    I18n.reload! if(Translation.changed?)
    I18n.locale = lang

    session[:lang] = lang
  end

  def page_path
    request.path[3..-1]
  end

  def metainfo_load
    @metainfo = Metainfo.for(session[:lang], page_path)
  end

  def admin_required
    login_required
    return if performed?
    render :text=>t('message.common.access_denied'), :status=>403  unless current_user.admin?
  end

  def editor_required
    login_required
    return if performed?
    render :text=>t('message.common.access_denied'), :status=>403  unless current_user.editor?
  end

  def default_url_options(options={})
    {:lang=>I18n.locale || 'en'}
  end

  def params_to_lang(lang)
    {
      controller: controller_name, lang: lang, id: params[:id],
      user_id: params[:user_id], conference_id: params[:conference_id],
      category: params[:category], name: params[:name], action: action_name
    }
  end

  #FIXME refactor
  def accepted_languages(header)
    # no language accepted
    return [] if header.nil?

    # parse Accept-Language
    accepted = header.split(",")
    accepted = accepted.map { |l| l.strip.split(";") }
    accepted = accepted.find_all {|l| l.size == 1 || l.size == 2}
    accepted = accepted.map { |l|
      if (l.size == 2)
        # quality present
        [ l[0].split("-")[0].downcase, l[1].sub(/^q=/, "").to_f ]
      else
        # no quality specified =&gt; quality == 1
        [ l[0].split("-")[0].downcase, 1.0 ]
      end
    }

    # sort by quality
    accepted.sort { |l1, l2| l1[1] <=> l2[1] }
  end

  def preferred_language(supported_languages = [], default_language = I18n.default_locale)
    h = request.env["HTTP_ACCEPT_LANGUAGE"]
    # only keep supported languages
    preferred_languages = accepted_languages(h).select {|l|
      (supported_languages || []).include?(l[0]) }

    if preferred_languages.empty?
      # the browser does accept any supported languages
      # => default to english
      default_language
    else
      # take the highest quality among accepted (and thus supported) languages
      preferred_languages.last[0]
    end
  end

  def admin?
    current_user.try(:admin?)
  end

  def editor?
    current_user.try(:editor?)
  end

  def reviewer?
    current_user.try(:reviewer?)
  end

  def not_found_error_handler(*exception)
    m = request.path.match(/^(\/\w{2}\/)(.*)$/)
    if m
      path = m[2]
      red = NotFoundRedirect.find_by_path path
      if red
        to = m[1] + red.target
        return redirect_to to
      end
    end
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end

  def site_select
    @site ||= Site.default.first
  end
end
