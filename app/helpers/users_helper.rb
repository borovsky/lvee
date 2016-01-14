module UsersHelper
  PRIORITY_COUNTRIES = ['belarus', 'ukraine', 'russia']

  def describe_user(user)
    translate('message.user.describe', :full_name => user.full_name,
      :country => user.country.humanize.titleize,
      :city => user.city)
  end

  def country_column(record, column)
    h(record.user.country).titleize
  end

  def active_scaffold_input_country(column, options)
    priority = PRIORITY_COUNTRIES
    select_options = {:prompt => as_(:_select_)}
    select_options.merge!(options)
    country_select(:record, column.name, column.options[:priority] || priority, select_options, column.options)
  end

  def as_(param, opts={})
    t("label.user.#{param}", :default => t("label.common.#{param}"))
  end
end
