class InfoMailer < ActionMailer::Base
  default :from => "#{INFO_MAIL}"

  def info_mail(to, subject, text)
    mail(:to => to, :subject => subject, :body => text)
  end
end
