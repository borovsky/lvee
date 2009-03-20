module ConferenceRegistrationsHelper
  def as_(param)
    t("label.conference_registration.#{param}", :default => t("label.common.#{param}"))
  end
end
