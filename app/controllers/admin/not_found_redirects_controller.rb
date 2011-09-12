class Admin::NotFoundRedirectsController < ApplicationController
  active_scaffold :not_found_redirect do |conf|
    conf.columns = [:path, :target]
    conf.actions.exclude :show, :search
    conf.list.per_page = 100
  end
end 