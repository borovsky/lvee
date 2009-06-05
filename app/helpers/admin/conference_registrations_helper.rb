module Admin
  module ConferenceRegistrationsHelper

    def city_column(record)
      h(record.user.city)
    end

    def country_column(record)
      h(record.user.country)
    end

    def avator_column(record)
      image_tag(url_for_file_column(record.user, "avator")) if record.user.avator
    end

    def projects_column(record)
      simple_format record.user.projects
    end

    def work_column(record)
      h(record.user.occupation)
    end
  end
end
