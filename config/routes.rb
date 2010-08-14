Rails.application.routes.draw do
  root :to => 'main#select_lang'

  match 'djs/ie_fuck.js' => 'djs_css#ie_fuck'

  match "activate/:activation_code" => 'users#activate'
  match 'sitemap.xml' => 'main#sitemap'
  match 'sitemap-news.xml' => 'main#sitemap_news'

  scope "/:lang", :constraints => {:lang => /[a-z]{2}/} do
    namespace :admin do
      get "/users/:to_list/mail" => 'info_mailer#index', :as => "mail_user"
      put "/users/mail" => 'info_mailer#send_mail'

      resources :users do
        put :set_role, :on => :member
      end
      resources :conference
      resources :conference_registrations do
        collection do
          get :csv
        end
      end
      resources :statuses
      resources :sponsors
    end

    namespace :editor do
      resources :languages do
        put :upload, :on => :member
        get :download, :on => :member
      end
      resources :metainfos do
        collection do
          put :change
        end
      end
      resources :image_uploads
    end

    match "/main" => 'main#index', :as => "main_page"
    resource  :session

    get "statistics/conference/:id" => 'statistics#conference', :as => "statistics_conference"
    get "statistics(/:length)" => 'statistics#access', :defaults => {:length => "full"}, :constraints => {:length => /(full|week|month)/}, :as => "statistics"

    match "conference_registrations/:id" => 'conference_registrations#user_list', :as => "conference_registration_list"
    match "users/:id/upload_avator" => 'users#upload_avator', :as => "upload_user_avator"
    match "users/list" => 'users#list'

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

    match 'articles/:id/diff(/:version)' => 'articles#diff', :as => "diff_article"
    match 'wiki_pages/:id/diff(/:version)' => 'wiki_pages#diff', :as => 'diff_wiki_page'
    match 'wiki_rss' => 'main#wiki_rss', :as => 'wiki_rss'

    resources :articles do
      get :translate, :on => :member
      put :preview, :on => :collection
    end

    match ':category(/:name)' => 'articles#show', :constraints => {:category => /(conference|contacts|sponsors|reports)/},
        :defaults => {:name => "index"}

    resources :wiki_pages do
      put :preview, :on => :collection
    end    
  end
end
