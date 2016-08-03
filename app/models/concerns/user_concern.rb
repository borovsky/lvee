module UserConcern
  extend ActiveSupport::Concern

  included do
    after_create  :generate_activation_code,
                  :sent_activation_code

    after_save    :subscribe_to_lists
  end

  def generate_activation_code
    self.update_attribute :activation_code, Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def sent_activation_code
    UserMailer.signup_notification(self).deliver_now
  end

  def subscribe_to_lists
    return if !self.active?

    if self.subscribed?
      MaillistSubscriber.subscribe(ALL_USER_MAILLIST, self.email)
    else
      MaillistSubscriber.unsubscribe(ALL_USER_MAILLIST, self.email)
    end

    if self.subscribed_talks?
      MaillistSubscriber.subscribe(TALKS_MAILLIST, self.email)
    else
      MaillistSubscriber.unsubscribe(TALKS_MAILLIST, self.email)
    end
  end
end
