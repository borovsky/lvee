module Admin
  class StatusesController < ApplicationController
    include ActiveScaffold

    before_filter :admin_required, :scaffold_action

    layout "admin"
    before_filter

    active_scaffold :statuses do
      self.columns = [:name, :subject, :mail]
      self.list.columns = [:name, :subject]
    end
  end
end
