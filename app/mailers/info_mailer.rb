class InfoMailer < ActionMailer::Base
  default :from => "info@lvee.org"

  def info_mail(to, subject, text)
    mail(:to => to, :subject => subject, :body => text)
  end
end
