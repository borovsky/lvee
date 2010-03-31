class StatisticsReportOs
  extend  Garb::Resource

  metrics :visits
  dimensions :operatingSystem
end
