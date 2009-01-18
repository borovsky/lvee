class Status < ActiveRecord::Base
  def self.find_by_name(name)
    # Search status by name and user's locale
    status = find_first_by_name_and_locale(name, I18n.locale.to_s)
    return status if status
    # Search status by name and default locale
    status = find_first_by_name_and_locale(name, I18n.default_locale.to_s)
    return status if status
    # Search first available status
    status = find_first_by_name(name)
    return status
  end
end
