class ConferenceRegistrationObserver < ActiveRecord::Observer
  def after_save(reg)
    send_email_if_status_changed(reg)
    populate_badges(reg)
  end

  def send_email_if_status_changed(reg)
    if reg.status_name_changed?
      UserMailer.status_changed(reg).deliver
    end
  end

  def populate_badges(reg)
    if reg.quantity
      while reg.badges.length < reg.quantity
        reg.badges.create(:top => reg.user.full_name, :bottom => reg.user.from)
      end

      while reg.badges.length > reg.quantity
        reg.badges.delete(reg.badges.last)
      end
    end
  end
end
