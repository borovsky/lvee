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

    def filled_column(record)
      ((record.quantity || 0) > 0) and
        !record.days.blank? and
        !record.transport_to.blank? and
        !record.transport_from.blank?
    end

    def status_name_form_column(record, input_name)
      select "record", "status_name", Status.available_statuses
    end

    def user_type_form_column(record, input_name)
      select "record", "user_type", ['normal', 'organizer', 'sponsor', 'reporter']
    end

    def work_form_column(record, input_name)
      text = h(record.user.occupation)
      content_tag(:span, text, :class => "static-value")
    end

    def projects_form_column(record, input_name)
      text = simple_format(record.user.projects)
      content_tag(:span, text, :class => "static-value")
    end

    def avator_form_column(record, input_name)
      text = image_tag(url_for_file_column(@record.user, "avator")) if @record.user.avator
      content_tag(:span, text, :class => "static-value")
    end

    def comment_form_column(record, input_name)
      text_area "record", "comment"
    end
  end
end
