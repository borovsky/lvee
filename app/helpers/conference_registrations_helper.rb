module ConferenceRegistrationsHelper
  def as_(param, opts={})
    t("label.conference_registration.#{param}", :default => t("label.common.#{param}"))
  end
end
