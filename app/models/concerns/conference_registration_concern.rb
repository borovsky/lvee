module ConferenceRegistrationConcern
  extend ActiveSupport::Concern

  included do
    after_save  :send_email_if_status_changed,
                :populate_badges
  end

  def send_email_if_status_changed
    UserMailer.status_changed(self).deliver_now if self.status_name_changed?
  end

  def populate_badges
    if self.badges.length < self.quantity
      self.badges.create(:top => self.user.full_name, :bottom => self.user.from)
    end
    while self.badges.length < self.quantity
      self.badges.create(:top => "", :bottom => "")
    end

    #delete unnecessary badges after second filling form(after approving)
    while self.badges.length > self.quantity
      self.badges.delete(self.badges.last)
    end
  end
end
