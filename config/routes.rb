Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  root 'static_pages#home'
  match '/recent',      to: 'static_pages#recent',     via: 'get'
  match '/report',      to: 'static_pages#report',     via: 'get'
  match '/about',       to: 'static_pages#about',      via: 'get'
  match '/faq',         to: 'static_pages#faq',        via: 'get'
  match '/service',     to: 'static_pages#service',    via: 'get'
  match '/privacy',     to: 'static_pages#privacy',    via: 'get'
  match '/tutorial',    to: 'static_pages#tutorial',   via: 'get'
  match '/opensource',  to: 'static_pages#opensource', via: 'get'
  match "/sitemap.xml", to: 'static_pages#sitemap', format: 'xml', via: 'get'

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confimations: "users/confirmations"
   }

  match '/legislators/no_record',   to: 'legislators#no_record',   via: 'get', as: 'legislators_no_record'
  match '/legislators/has_records', to: 'legislators#has_records', via: 'get', as: 'legislators_has_records'
  match '/legislators/search',      to: 'legislators#search',      via: 'get', as: 'legislators_search'
  match '/legislators/result',      to: 'legislators#result',      via: 'get', as: 'legislators_result'
  resources :legislators, only: [:show, :index] do
    member do
      get 'entries'
      get 'interpellations'
      get 'videos'
      get 'votes'
      get 'bills'
      get 'candidate'
      get 'ccw'
    end
  end

  resources :entries
  resources :interpellations
  resources :videos
  resources :ccws, only: [:show, :index]
  scope '/admin' do
    resources :users, except: [:show, :new, :create] do
      member do
        get 'confirm'
      end
    end
    resources :parties
    root 'admins#index',             via: 'get', as: 'admin'
    match 'entries',          to: 'admins#entries',          via: 'get', as: 'admin_entries'
    match 'interpellations',        to: 'admins#interpellations',        via: 'get', as: 'admin_interpellations'
    match 'videos',           to: 'admins#videos',           via: 'get', as: 'admin_videos'
    match 'data',             to: 'admins#data',             via: 'get', as: 'admin_data'
    match 'update_entries',   to: 'admins#update_entries',   via: 'put'
    match 'update_interpellations', to: 'admins#update_interpellations', via: 'put'
    match 'update_videos',    to: 'admins#update_videos',    via: 'put'
  end

  match "/404" => "errors#error404", via: [ :get, :post, :patch, :delete ], as: 'not_found'
  match "/422" => "errors#error422", via: [ :get, :post, :patch, :delete ]
  match "/500" => "errors#error500", via: [ :get, :post, :patch, :delete ]

  # resources :keywords

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
