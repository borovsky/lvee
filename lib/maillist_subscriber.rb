class MaillistSubscriber
  MAILMAN_SUBSCRIBE = '/usr/sbin/add_members'
  MAILMAN_UNSUBSCRIBE = '/usr/sbin/remove_members'

  def self.subscribe(list, email)
    return false unless validate_params(email, list)
    return false if MaillistSubscription.find_by_email_and_maillist(email, list)
    IO.popen("sudo #{MAILMAN_SUBSCRIBE} -r - '#{list}'", 'w') do |f|
      f.puts(email)
    end
    MaillistSubscription.create(:email => email, :maillist => list)
  end

  def self.unsubscribe(list, email)
    return false unless validate_params(email, list)
    ms = MaillistSubscription.find_by_email_and_maillist(email, list)
    return false unless ms
    system("sudo #{MAILMAN_UNSUBSCRIBE} '#{list}' '#{email}'")
    ms.destroy
  end

  private
  # validates params for prevent shell command execution
  def self.validate_params(email, list)
    return false unless email =~ /^[-a-zA-Z.0-9@]+$/
    return false unless list =~ /^[-a-zA-Z.0-9]+$/
    true
  end
end
