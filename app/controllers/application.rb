# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ApplicationHelper

  include ExceptionNotifiable

  before_filter :language_select

  protect_from_forgery # :secret => 'dc50c44338f5eba496ede18e9ea29cb1'

  ActiveScaffold.set_defaults do |config|
    # disables dhtml history globally
    config.dhtml_history = false
  end

  protected
  def language_select
    lang = params[:lang] || session[:lang] || preferred_language(Language.published_names)

    if(LANGUAGE_MAP[lang])
      return redirect_to params_to_lang(LANGUAGE_MAP[lang])
    end

    unless (lang.blank? || lang ==~ /[a-z]{2,3}/ || File.join(LOCALE_DIR, "#{lang}.yml"))
      return redirect_to("/")
    end

    #FIXME
    I18n.load_path = Dir.glob(LOCALE_DIR+ "*.yml")
    I18n.reload!
    I18n.locale = lang

    session[:lang] = lang
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
    {:lang=>I18n.locale}
  end

  def params_to_lang(lang)
    {:controller => controller_name, :lang => lang, :id => params[:id],
        :user_id => params[:user_id], :conference_id => params[:conference_id],
        :category => params[:category], :name => params[:name], :action => action_name}
  end

  def scaffold_action
    @active_scaffold = true
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

end
