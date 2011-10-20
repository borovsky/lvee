module StatisticsHelper

  def fetch_statistics
    unless @report_country && @report_country && @report_country
      Garb::Session.login(GOOGLE_LOGIN, GOOGLE_PASSWORD)
      @profile = Garb::Management::Profile.all.first
      from_date = case params[:length]
                  when "week" then 7.days.ago
                  when "month" then 1.month.ago
                  else Date.parse("2009-04-20")
                  end
      @report_country = StatisticsReportCountry.results(@profile, :limit => 30, :start_date => from_date, :sort => :visits.desc) do
        sort()
      end
      @report_os = StatisticsReportOs.results(@profile, :limit => 10, :start_date => from_date, :sort => :visits.desc) do
        sort(:visits.desc)
      end
      @report_browser = StatisticsReportBrowser.results(@profile, :limit => 10, :start_date => from_date, :sort => :visits.desc) do
        sort(:visits.desc)
      end

      @total_visitors = @report_os.inject(0) {|sum, i| sum + i.visits.to_i }
    end
  end
end
