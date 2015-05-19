Rails.application.routes.draw do
  root :to => 'main#select_lang'

  match 'djs/ie_fuck.js' => 'djs_css#ie_fuck'

  match "activate/:activation_code" => 'users#activate'
  match 'sitemap.xml' => 'main#sitemap'
  match 'sitemap-news.xml' => 'main#sitemap_news'

  scope "/:lang", constraints: {lang: /[a-z]{2}/} do
    namespace :admin do
      get "/users/:to_list/mail" => 'info_mailer#index', as: "mail_user"
      put "/users/mail" => 'info_mailer#index'
      put "/users/send_mail" => 'info_mailer#send_mail', as: "send_email"
      post "/users/send_mail" => 'info_mailer#send_mail', as: "send_email"
      resources :users do
        post :set_role, on: :member
      end

      resources :conferences do
        as_routes
        member do
          get :registrations
          get :csv
          get :badges_pdf
        end
      end
      resources :conference_registrations do
        as_routes
        collection do
          get :csv
          get :show_statistics
          post :approve_all
          get :approve_all, action: :approve_all_view
        end
      end
      resources :statuses do
        as_routes
      end
      resources :sponsors do
        as_routes
      end
      resources :not_found_redirects do
        as_routes
      end
      resources :sites do
        as_routes
      end
      match "/import(/:action)", controller: "import"
      match '/conferences/registrations/:id' => "conferences#registrations"

      resources :menus
    end

    namespace :editor do
      resources :languages do
        as_routes
        get :upload_form, on: :member
        post :upload, on: :member
      end
      resources :metainfos do
        as_routes
        collection do
          put :change
        end
      end
      resources :image_uploads do
        as_routes
      end

      resources :translations
    end

    match "/main" => 'main#index', as: "main_page"
    resource  :session

    get "statistics/conference/:id" => 'statistics#conference', as: "statistics_conference"
    get "statistics(/:length)" => 'statistics#access', defaults: {length: "full"},
      constraints: {length: /(full|week|month)/ }, as: "statistics"

    match "conference_registrations/:id" => 'conference_registrations#user_list', as: "conference_registration_list"
    match "users/:id/upload_avatar" => 'users#upload_avatar', as: "upload_user_avator"
    match "users/list" => 'users#list'
    match "users/volunteers" => 'articles#show', defaults: {category: 'users', name: "volunteers"}

    resources :users do
      as_routes
      get :activate, :on => :member
      collection do
        get :current
        match :restore
        get "for_selection"
      end

      resources :conference_registrations do
        as_routes
        member do
          match :badges
          match :cancel
        end
      end
    end

    resources :abstracts, :except => [:destroy] do
      put :preview, :on => :collection
      member do
        post :add_comment
        post :add_users
        post :publish
        post :unpublish
        match :diff
        post :upload_file
        delete "delete_file/:file_id" => :delete_file, as: "delete_file"
        post :add_participants
      end
    end

    get "news/:parent_id/translate/:locale" => "news#new", as: "translate_news"

    resources :news, as: 'news_item' do
      collection do
        get :rss
        put :preview
      end
      member do
        get :publish
        get :publish_now
      end
    end

    match 'articles/:id/diff(/:version)' => 'articles#diff', as: "diff_article"
    match 'wiki_pages/:id/diff(/:version)' => 'wiki_pages#diff', as: 'diff_wiki_page'
    match 'wiki_rss' => 'main#wiki_rss', as: 'wiki_rss'
    match 'main/editor_rss' => 'main#editor_rss', as: 'editor_rss'

    resources :articles do
      get :translate, on: :member
      put :preview, on: :collection
    end

    match ':category(/:name)' => 'articles#show', constraints: {category: /(conference|contacts|sponsors|reports)/},
      defaults: {name: "index"}, as: :article_by_name

    resources :wiki_pages do
      put :preview, on: :collection
    end
  end
  match '*a', :to => 'errors#routing'
end
