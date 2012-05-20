class UserMailer < ActionMailer::Base
  default :from => "info@lvee.org"
  PREFIX = "[lvee] "

  def signup_notification(user)
    @user = user
    @url = "http://summer.lvee.org/activate/#{user.activation_code}"
    mail :to => user.email, :subject => PREFIX + I18n.t('mail.subject.activation')
  end

  def activation_restore(user)
    @user = user
    @url = "http://summer.lvee.org/activate/#{user.activation_code}"

    mail :to => user.email, :subject => PREFIX + I18n.t('mail.subject.activation_restore')
  end


  def activation(user)
    @user = user
    @url = "http://summer.lvee.org/"

    mail :to => user.email, :subject => PREFIX + I18n.t('mail.subject.activation_complete')
  end

  def password_restore(user, ip)
    @user = user
    @url = "http://summer.lvee.org/"
    @ip = ip

    mail :to => user.email, :subject => PREFIX + I18n.t('mail.subject.password_restore')
  end

  def status_changed(conference_registration)
    user = conference_registration.user
    conference = conference_registration.conference
    status = Status.find_by_name(conference_registration.status_name)

    mail :to => user.email, :subject => PREFIX + ERB.new(status.subject).result(binding) do |format|
      format.text{ render :text => ERB.new(status.mail).result(binding)}
    end
  end
end
