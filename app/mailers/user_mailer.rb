class UserMailer < ActionMailer::Base
  default :from => "#{INFO_MAIL}"
  PREFIX = "[#{SITE_TITLE}] "

  def signup_notification(user)
    @user = user
    @url = "#{SITE_URL}activate/#{user.activation_code}"
    mail :to => user.email, :subject => PREFIX + I18n.t('mail.subject.activation')
  end

  def activation_restore(user)
    @user = user
    @url = "#{SITE_URL}activate/#{user.activation_code}"

    mail :to => user.email, :subject => PREFIX + I18n.t('mail.subject.activation_restore')
  end

  def activation(user)
    @user = user
    @url = "#{SITE_URL}"

    mail :to => user.email, :subject => PREFIX + I18n.t('mail.subject.activation_complete')
  end

  def password_restore(user, ip)
    @user = user
    @url = "#{SITE_URL}"
    @ip = ip

    mail :to => user.email, :subject => PREFIX + I18n.t('mail.subject.password_restore')
  end

  def status_changed(conference_registration)
    user = conference_registration.user
    conference = conference_registration.conference
    status = Status.where(name: conference_registration.status_name).take

    mail :to => user.email, :subject => PREFIX + ERB.new(status.subject).result(binding) do |format|
      format.text{ render :text => ERB.new(status.mail).result(binding)}
    end
  end

  def commented(abstract) #TODO ever remove
    user = User.find(abstract.author_id)
    conference = Conference.find(abstract.conference_id)
    mail_subject = "Your abstracts to <%= conference.name %> have been commented"
    mail_body = "Hello <%= user.full_name %>

You've got a comment to your abstracts for <%= conference.name %>

Вы получили комментарий рецензента к своим тезисам, поданным на  <%= conference.name %>

--
#{SITE_TITLE} team"

    mail :to => user.email, :subject => PREFIX + ERB.new(mail_subject).result(binding) do |format|
      format.text{ render :text => ERB.new(mail_body).result(binding)}
    end
  end

end
