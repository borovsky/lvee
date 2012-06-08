module Admin
  class StatusesController < ApplicationController
    before_filter :admin_required

    layout "admin"

    active_scaffold :status do
      self.columns = [:name, :subject, :mail]
      self.list.columns = [:name, :subject]
    end
  end
end
