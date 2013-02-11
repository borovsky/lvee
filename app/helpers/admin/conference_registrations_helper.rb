module Admin
  module ConferenceRegistrationsHelper

    def city_column(record, column)
      h(record.user.city)
    end

    def country_column(record, column)
      h(record.user.country)
    end

    def avator_column(record, column)
      image_tag(record.user.avator.url) if record.user.avator && record.user.avator.url
    end

    def projects_column(record, column)
      simple_format record.user.projects
    end

    def work_column(record, column)
      h(record.user.occupation)
    end

    def filled_column(record, column)
      record.filled?
    end

    def status_name_form_column(record, input_name)
      select "record", "status_name", Status.available_statuses
    end

    def user_type_form_column(record, input_name)
      select "record", "user_type", ['normal', 'organizer', 'sponsor', 'reporter', 'press']
    end

    def work_form_column(record, input_name)
      return nil unless record.user
      text = h(record.user.occupation)
      content_tag(:span, text, :class => "static-value")
    end

    def projects_form_column(record, input_name)
      return nil unless record.user
      text = simple_format(record.user.projects)
      content_tag(:span, text, :class => "static-value")
    end

    def avator_form_column(record, input_name)
      return nil unless record.user
      text = image_tag(record.user.avator.url) if record.user.avator.url
      content_tag(:span, text, :class => "static-value")
    end

    def comment_form_column(record, input_name)
      text_area "record", "comment"
    end
  end
end
