class MainController < ApplicationController

  def index
    @news = News.published.find(:all, :limit => 5)
  end

  def select_lang
    langs =  accepted_languages
    lang = langs.empty? ? 'en' : langs.last[0]
    redirect_to :controller => "main", :action =>'index', :lang => lang
  end

  protected
  def accepted_languages()
    # no language accepted
    return [] if request.env["HTTP_ACCEPT_LANGUAGE"].nil?

    # parse Accept-Language
    accepted = request.env["HTTP_ACCEPT_LANGUAGE"].split(",")
    accepted = accepted.map { |l| l.strip.split(";") }
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

  def preferred_language(supported_languages=[], default_language="en")
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
