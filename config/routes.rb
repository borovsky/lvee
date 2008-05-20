ActionController::Routing::Routes.draw do |map|

  map.connect 'activate/:activation_code', :controller => 'users', :action => 'activate'

  map.resources :users, :member => { :activate => :get }

  map.resource  :session

  map.resources :news, :has_many => [:comments], :has_one => :user, :singular => 'news_item'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #map.connect 'about/:action', :controller => 'about'
  #map.connect ':lang/about/:action', :controller => 'about'

  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  map.root :controller => "main", :lang => 'ru'


  # Install the default routes as the lowest priority.
  map.connect ':lang/:controller/:action/:id'
  map.connect ':lang/:controller/:action/:id.:format'

  # Deprecated 
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
