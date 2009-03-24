ActionController::Routing::Routes.draw do |map|
  map.root :controller => "main", :action=>"select_lang"

  map.connect 'djs/ie_fuck.js', :controller => 'djs_css', :action => 'ie_fuck'

  map.connect 'activate/:activation_code', :controller => 'users', :action => 'activate'
  map.connect 'sitemap.xml', :controller => 'main', :action => 'sitemap'

  map.namespace :admin, :namespace => "", :path_prefix =>":lang", :name_prefix => "" do |admin|
    admin.resources :users
    admin.resources :conferences, :active_scaffold => true
    admin.resources :conference_registrations, :active_scaffold => true
    admin.resources :statuses, :active_scaffold => true
  end
  map.namespace :editor, :namespace => "", :path_prefix =>":lang", :name_prefix => "" do |editor|
    editor.resources :languages
    editor.resources :image_uploads, :active_scaffold => true
  end


  map.with_options :path_prefix =>":lang", :requirements => {:lang => /[a-z]{2}/} do |ns|
    ns.connect 'main', :controller => "main", :action => "index"

    ns.connect('users/privacy/:action', :requirements =>
      {:category => 'users', :name => "privacy"},
      :controller=> "articles",
      :defaults => {:action => "show"})


    ns.translate_news "news/:parent_id/translate/:locale",  :controller => "news", :action => "new"
    ns.resources(:news,
      :singular => 'news_item',
      :collection => {:rss => :get, :preview=>:post},
      :member => {:publish => :get, :publish_now => :get})

    ns.resources :articles, :member => {:translate => :get},
      :collection => {:preview=>:put}

    ns.connect('about/:name/:action',
      :controller=> "articles", :category => "conference",
      :defaults => {:action => "show", :name => "index"})

    ns.connect(':category/:name/:action', :requirements =>
      {:category => /(main|conference|contacts|sponsors|reports)/},
      :controller=> "articles",
      :defaults => {:action => "show", :name => "index"})


    ns.upload_user_avator "users/:id/upload_avator", :controller=> "users", :action => "upload_avator"
    ns.resources :users, :member => { :activate => :get }, :collection => {:current => :get} do |m|1
      m.connect('conference_registrations/new/:conference_id',
        :controller => 'conference_registrations', :action => 'new')
      m.resources(:conference_registrations, :controller => 'conference_registrations',
        :active_scaffold => true)
    end
    ns.resource  :session

    ns.connect ':controller/:action/:id'
    ns.connect ':controller/:action/:id.:format'
  end

  map.connect('participants', :controller=> "articles", :category => "conference",
    :action => "show", :name => "index")



  map.connect ':lang', :controller => "main", :action=>"index"
end
