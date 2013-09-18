Sweaton2::Application.routes.draw do

  get "mentorships/index"
  get "password_resets/new"
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :venues
  resources :events do
    collection do
      match 'search' => 'events#index', :via => [:get, :post], :as => :search
    end
  end
  resources :tags, only: [:index, :show]
  resources :relationships, only: [:create, :destroy]
  resources :favourites, only: [:create, :destroy]
  resources :diary_entries
  resources :messages
  resources :mentorships
  resources :password_resets

  root 'static_pages#home'
  match '/signup',  to: 'users#new',		via: 'get'
  match '/signin',  to: 'sessions#new',		via: 'get'
  match '/signout', to: 'sessions#destroy',	via: 'delete' 
  match '/venues',  to: 'venues#index',		via: 'get'
  match '/inbox',   to: 'messages#inbox',   via: 'get'
  match '/my_events', to: 'static_pages#my_events', via: 'get'
  match '/mentoring', to: 'mentorships#index',  via: 'get'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
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
