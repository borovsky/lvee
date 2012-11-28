class Admin::SponsorsController < ApplicationController

  before_filter :admin_required
  layout "admin"

  active_scaffold :sponsor do
    self.columns = [:name, :sponsor_type, :url, :image]
  end
end
