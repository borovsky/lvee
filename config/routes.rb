ActionController::Routing::Routes.draw do |map|
  map.connect 'activate/:activation_code', :controller => 'users', :action => 'activate' # FIXME other langs?


  map.resources :users, :member => { :activate => :get } do |m|1
    m.resources :conference_registrations, :controller => 'conference_registrations'
  end
  map.resource  :session
  map.namespace :admin do |admin|
    admin.resources :users
    admin.resources :conferences
  end
  map.resources :news, :has_many => [:comments], :has_one => :user, :singular => 'news_item'

  map.root :controller => "main", :lang => 'ru'


  # Install the default routes as the lowest priority.
  map.connect ':lang/:controller/:action/:id', :defaults => { :lang => 'ru' }
  map.connect ':lang/:controller/:action/:id.:format', :defaults => { :lang => 'ru' }

end
