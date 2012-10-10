module Admin
  class SitesController < ApplicationController
    before_filter :admin_required

    layout "admin"

    STATIC_COLUMNS = [:stylesheet, :javascript]

    active_scaffold :site do |site|
      site.columns = [:name, :file, :default] + STATIC_COLUMNS
      STATIC_COLUMNS.each {|c| site.columns[c].form_ui = :static}
    end
  end
end
