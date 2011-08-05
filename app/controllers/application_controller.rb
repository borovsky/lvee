require 'authenticated_system'

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  before_filter :language_select
  before_filter :metainfo_load

  protect_from_forgery # :secret => 'dc50c44338f5eba496ede18e9ea29cb1'

  def cache_result_for(key, timeout, &block)
    key = fragment_cache_key(key)
    fragment = read_fragment(key)

    if(fragment.kind_of?(Array) and
        fragment.length == 2 and
        fragment.first > timeout.ago)
      return fragment.second
    end
    result = yield
    write_fragment(key, [Time.new, result])
    result
  end

  protected
  def language_select
    lang = params[:lang] || session[:lang]

    if(LANGUAGE_MAP[lang])
      return redirect_to(params_to_lang(LANGUAGE_MAP[lang]))
    end

    unless lang.blank?
      unless(lang =~ /[a-z]{2,3}/ and File.exists?(File.join(LOCALE_DIR, "#{lang}.yml")))
        session[:lang] = nil
        return redirect_to("/")
      end
    end

    #FIXME
    I18n.load_path = Dir.glob(LOCALE_DIR+ "*.yml")
    I18n.reload!
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
    logger.error(current_user.role)
    logger.error(current_user.admin?)
    render :text=>t('message.common.access_denied'), :status=>403  unless current_user.admin?
  end

  def editor_required
    login_required
    return if performed?
    render :text=>t('message.common.access_denied'), :status=>403  unless current_user.editor?
  end

  def default_url_options(options={})
    {:lang=>I18n.locale}
  end

  def params_to_lang(lang)
    {:controller => controller_name, :lang => lang, :id => params[:id],
        :user_id => params[:user_id], :conference_id => params[:conference_id],
        :category => params[:category], :name => params[:name], :action => action_name}
  end

  #FIXME refactor
  def accepted_languages
    # no language accepted
    return [] if request.env["HTTP_ACCEPT_LANGUAGE"].nil?

    # parse Accept-Language
    accepted = request.env["HTTP_ACCEPT_LANGUAGE"].split(",")
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
    accepted = accepted.find_all{|l| Language.find_by_name_and_published(l, true)}
    accepted.sort { |l1, l2| l1[1] <=> l2[1] }
  end

  def preferred_language(supported_languages=[], default_language=I18n.default_locale)
    # only keep supported languages
    preferred_languages = accepted_languages.select {|l|
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

  #FIXME
  def self.active_scaffold(*args)

  end
end
