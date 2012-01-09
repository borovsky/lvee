class UserObserver < ActiveRecord::Observer
  def before_create(user)
    user.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def after_create(user)
    UserMailer.signup_notification(user).deliver
  end

  def after_save(user)
    UserMailer.activation(user).deliver if user.recently_activated?  && !user.no_mail
    subscribe_to_lists(user)
  end

  def subscribe_to_lists(user)
    if user.subscribed?
      MaillistSubscriber.subscribe(ALL_USER_MAILLIST, user.email) if user.active?
    else
      MaillistSubscriber.unsubscribe(ALL_USER_MAILLIST, user.email)
    end
    if user.subscribed_talks?
      MaillistSubscriber.subscribe(TALKS_MAILLIST, user.email) if user.active?
    else
      MaillistSubscriber.unsubscribe(TALKS_MAILLIST, user.email)
    end
  end

end
