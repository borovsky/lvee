class InfoMailer < ActionMailer::Base
  def info_mail(to, subject, text, attachment)
    @recipients  = to
    @from = "info@lvee.org"
    @subject = subject
    @sent_on     = Time.now

    @body[:text]  = text

    
    attachment(:content_type => attachment.content_type,
      :body => attachment.read, 
      :filename => attachment.original_filename) unless attachment.blank?
    
  end
end
