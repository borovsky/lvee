module Admin
  module ConferenceRegistrationHelper
    
    def city_column(record)
      record.user.city
    end

    def country_column(record)
      record.user.country
    end
  end
end
