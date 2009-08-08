class Admin::SponsorsController < ApplicationController
  before_filter :admin_required, :scaffold_action
  layout "admin"

  active_scaffold :sponsors do
    self.columns = [:name, :sponsor_type, :url, :image]
  end
end
