ActionController::Routing::Routes.draw do |map|
  map.root :controller => "main", :action=>"select_lang"
  map.connect 'activate/:activation_code', :controller => 'users', :action => 'activate' # FIXME other langs?

  map.namespace :admin, :namespace => "", :path_prefix =>":lang", :name_prefix => "" do |admin|
    admin.resources :users
    admin.resources :conferences
  end
  map.namespace :editor, :namespace => "", :path_prefix =>":lang", :name_prefix => "" do |editor|
    editor.resources :languages
  end

  map.with_options :path_prefix =>":lang" do |ns|
    ns.resources :users, :member => { :activate => :get }, :collection => {:current => :get} do |m|1
      m.resources :conference_registrations, :controller => 'conference_registrations'
    end
    ns.resource  :session

    ns.translate_news "news/:parent_id/translate/:locale",  :controller => "news", :action => "new"
    ns.resources :news,
      :singular => 'news_item',
      :collection => {:rss => :get},
      :member => {:publish => :get, :publish_now => :get}

    ns.connect ':controller/:action/:id'
    ns.connect ':controller/:action/:id.:format'
  end
  map.connect ':lang', :controller => "main", :action=>"index"

end
