module StatisticsHelper

  def fetch_statistics
    unless @report_country && @report_country && @report_country
      Garb::Session.login(GOOGLE_LOGIN, GOOGLE_PASSWORD)
      @profile = Garb::Profile.all.first
      @report_country = StatisticsReportCountry.results(@profile, :limit => 30) do
        sort(:visits.desc)
      end
      @report_os = StatisticsReportOs.results(@profile, :limit => 10) do
        sort(:visits.desc)
      end
      @report_browser = StatisticsReportBrowser.results(@profile, :limit => 10) do
        sort(:visits.desc)
      end
    end
  end
end
