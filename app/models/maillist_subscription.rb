class MaillistSubscription < ActiveRecord::Base
  attr_accessible :email, :maillist
  validates :email, :uniqueness => {:scope => :maillist}
end
