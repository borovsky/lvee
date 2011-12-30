class InfoMailer < ActionMailer::Base
  default :from => "info@lvee.org"

  def info_mail(to, subject, text, attachment)
    
    attachment(:content_type => attachment.content_type,
      :body => attachment.read,
      :filename => attachment.original_filename) unless attachment.blank?

    mail(:to => to, :subject => subject, :body => text)
  end
end
