class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject += I18n.t('mail.subject.activation')

    @body[:url]  = "http://lvee.org/activate/#{user.activation_code}"
  end

  def activation_restore(user)
    setup_email(user)
    @subject += I18n.t('mail.subject.activation_restore')

    @body[:url]  = "http://lvee.org/activate/#{user.activation_code}"
  end


  def activation(user)
    setup_email(user)
    @subject += I18n.t('mail.subject.activation_complete')
    @body[:url]  = "http://lvee.org/"
  end

  def password_restore(user, ip)
    setup_email(user)
    @subject += I18n.t('mail.subject.password_restore')
    @body[:url]  = "http://lvee.org/"
    @body[:ip] = ip
  end

  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "info@lvee.org"
      @subject     = "[lvee.org] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
