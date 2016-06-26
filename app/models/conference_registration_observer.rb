class ConferenceRegistrationObserver < ActiveRecord::Observer
  def after_save(reg)
    send_email_if_status_changed(reg)
    populate_badges(reg)
  end

  def send_email_if_status_changed(reg)
    if reg.status_name_changed?
      UserMailer.status_changed(reg).deliver_now 
    end
  end

  def populate_badges(reg)
    if reg.badges.length < reg.quantity
      reg.badges.create(:top => reg.user.full_name, :bottom => reg.user.from)
    end
    while reg.badges.length < reg.quantity
      reg.badges.create(:top => "", :bottom => "")
    end

    #delete unnecessary badges after second filling form(after approving)
    while reg.badges.length > reg.quantity
      reg.badges.delete(reg.badges.last)
    end
  end
end
