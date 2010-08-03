require 'garb'

class StatisticsReportCountry
  extend  Garb::Resource

  metrics :visits
  dimensions :country
end
