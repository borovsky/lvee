ActionController::Routing::Routes.draw do |map|
  root :to => 'main#select_lang'

  match 'djs/ie_fuck.js' => 'djs_css#ie_fuck'

  match "activate/:activation_code" => 'users#activate'
  match 'sitemap.xml' => 'main#sitemap'
  match 'sitemap-news.xml' => 'main#sitemap_news'

  scope "/:lang", :constraints => {:lang => /[a-z]{2}/} do
    namespace :admin do
      resources :users
      resources :conference
      resources :conference_registrations do
        collection do
          get :csv
        end
      end
      resources :statuses
      resources :sponsors
      match "/users/:to_list/mail" => 'info_mailer#index', :as => "mail_user"
    end

    namespace :editor do
      resources :languages
      resources :metainfos do
        collection do
          put :change
        end
      end
      resources :image_uploads
    end

    match "/main" => 'main#index', :as => "main_page"
    resource  :session
    resources :users do
      get :activate, :on => :member
      collection do
        get :current
        match :restore
      end

      resources :conference_registrations do
        member do
          match :badges
          match :cancel
        end
      end
    end
    
    get "news/:parent_id/translate/:locale" => "news#new", :as => "translate_news"

    resources :news, :as => 'news_item' do
      collection do
        get :rss
        put :preview
        get :editor_rss
      end
      member do
        get :publish
        get :publish_now
      end
    end

    resources :articles do
      get :translate, :on => :member
      put :preview, :on => :collection
    end

    match ':category(/:name)' => 'articles#show', :constraints =>
        {:category => /(conference|contacts|sponsors|reports)/},
        :defaults => {:name => "index"}

    resources :wiki_pages do
      put :preview, :on => :collection
    end
  end
end

if false

  map.with_options :path_prefix =>":lang", :requirements => {:lang => /[a-z]{2}/} do |ns|
    ns.editor_rss 'editor_rss', :controller => "main", :action => "editor_rss"
    ns.wiki_rss 'wiki_rss', :controller => "main", :action => "wiki_rss"

    ns.statistics_conference "statistics/conference/:id", :controller => "statistics", :action => "conference"
    ns.statistics "statistics/:length", :controller => "statistics", :action => "index",
      :defaults => {:length => "full" }, :conditions => {:length => /(full|week|month)/}

    ns.diff_article('articles/:id/diff/:version', :controller => "articles", :action => "diff",
      :defaults => {:version => nil})
    ns.diff_wiki_page('wiki_pages/:id/diff/:version',
      :controller => "wiki_pages", :action => "diff", :defaults => {:version => nil})

    ns.connect('users/privacy', :requirements =>
        {:category => 'users', :name => "privacy"},
      :controller=> "articles", :action => "show")

    ns.connect('users/volunteers', :requirements =>
        {:category => 'users', :name => "volunteers"},
      :controller=> "articles", :action => "show")

    ns.connect('about/:name',
      :controller=> "articles", :category => "conference", :action => "show",
      :defaults => {:name => "index"})

    ns.connect(':category/:name', :requirements =>
        {:category => /(conference|contacts|sponsors|reports)/},
      :controller=> "articles", :action => "show",
      :defaults => {:name => "index"})


    ns.upload_user_avator "users/:id/upload_avator", :controller=> "users", :action => "upload_avator"

    ns.conference_registration_list("conference_registrations/:id",
      :controller => 'conference_registrations', :action => 'user_list')

    ns.connect "users/list", :controller => "users", :action => "list"
    ns.resources :users, :member => { :activate => :get },
      :collection => {:current => :get, :restore => :any} do |m|
      m.connect('conference_registrations/new/:conference_id',
        :controller => 'conference_registrations', :action => 'new')
      m.resources(:conference_registrations, :controller => 'conference_registrations',
        :active_scaffold => true, :member => {:badges => :any, :cancel => :any})
    end
    ns.resource  :session

    ns.connect ':controller/:action/:id'
    ns.connect ':controller/:action/:id.:format'
  end

  map.connect('participants', :controller=> "articles", :category => "conference",
    :action => "show", :name => "index")

  map.connect ':lang', :controller => "main", :action=>"index"
end
