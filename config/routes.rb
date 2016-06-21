Rails.application.routes.draw do

  # scope "(:locale)", :locale => /en|th/ do
    root 'static_pages#index'

    get 'login' => 'sessions#new'
    post 'login' => 'sessions#create'
    delete 'logout' => 'sessions#destroy'

    get 'page2' => 'static_pages#page2'
    get 'settings' => 'static_pages#settings'

    get 'admin/menu' => 'admin#menu'
    get 'admin/all_sales' => 'admin#all_sales'
    get 'admin/all_announcements' => 'admin#all_announcements'
    get 'admin/all_deals' => 'admin#all_deals'

    resources :users do
      post 'update_role' => 'users#update_role'

      resources :sales

      get 'announcements' => 'announcements#user_announcements', :as => 'announcements'
      get 'announcements/:announcement_role' => 'announcements#user_announcements_role', :as => 'announcements_role'
    end

    resources :announcements
    resources :deals, only: [:index, :show, :create, :destroy] do
      patch 'update_status_decline_accepted' => 'deals#update_status_decline_accepted'
      patch 'update_status_paid' => 'deals#update_status_paid'
      patch 'update_status_shipped' => 'deals#update_status_shipped'
      resources :messages, only: [:index, :create]
    end
    resources :reviews, only: [:create]

    get 'analytics' => 'analytics#index'
    get 'announcement/analytics/' => 'analytics#announcement_analytics', as: "announcement_analytics"

  # end
  # resources :users

  resources :provinces do
    resources :amphurs, only: [:index] do
      resources :districts, only: [:index]
    end
  end

  get 'district' => 'districts#show'
  get 'districtamphur' => 'districts#show_amphur'
  get 'districtprovince' => 'districts#show_province'

  get 'auth/twitter',   as: 'login_twitter'
  get 'auth/facebook',  as: 'login_facebook'
  get 'auth/google_oauth2', as: 'login_google'
  match 'auth/:provider/callback', to: 'sessions#create_with_single_sign_on', via: [:get, :post]

  get '/auth/failure' do
    flash[:danger] = params[:message]
    redirect '/'
  end

  # root 'static_pages#index'
  # get 'page2' => 'static_pages#page2'

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
