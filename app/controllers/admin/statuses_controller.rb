module Admin
  class StatusesController < ApplicationController
    before_filter :admin_required, :scaffold_action

    layout "admin"
    before_filter

    active_scaffold :statuses
  end
end
