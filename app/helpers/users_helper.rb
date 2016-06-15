module UsersHelper

  def describe_user(user)
    translate('message.user.describe', :full_name => user.full_name,
      :country => user.country.humanize.titleize,
      :city => user.city)
  end

end
