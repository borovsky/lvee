class MaillistSubscription < ActiveRecord::Base
  validates_uniqueness_of   :email, :scope => :maillist
end
