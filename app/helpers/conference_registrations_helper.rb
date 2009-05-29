module ConferenceRegistrationsHelper
  def as_(param, opts={})
    t("label.conference_registration.#{param}", :default => t("label.common.#{param}"))
  end

  def transport_options(current, type = "from")
    values = TRANSPORT.map do |i|
      [t("label.conference_registration.transport_#{type}_list.#{i}"), i]
    end
    values = [t("label.common._select_"), ""] + values
    options_for_select(values, current)
  end
end
