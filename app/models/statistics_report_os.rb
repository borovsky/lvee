require 'garb'

class StatisticsReportOs
  extend  Garb::Model

  metrics :visits
  dimensions :operatingSystem
end
