class MaillistSubscription < ActiveRecord::Base
  validates :email, :uniqueness => {:scope => :maillist}
end
