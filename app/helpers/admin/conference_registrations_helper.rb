module Admin
  module ConferenceRegistrationsHelper

    def city_column(record)
      record.user.city
    end

    def country_column(record)
      record.user.country
    end

    def avator_column(record)
      image_tag(url_for_file_column(record.user, "avator")) if record.user.avator
    end
  end
end
