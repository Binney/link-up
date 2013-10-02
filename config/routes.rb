Sweaton2::Application.routes.draw do

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
  resources :reviews
  resources :articles

  root 'static_pages#home'
  match '/signup',  to: 'users#new',		        via: 'get'
  match '/signin',  to: 'sessions#new',		      via: 'get'
  match '/signout', to: 'sessions#destroy',	    via: 'delete' 
  match '/endsession', to: 'sessions#destroy',	via: 'get' 
  match '/venues',  to: 'venues#index',		      via: 'get'
  match '/inbox',   to: 'messages#inbox',       via: 'get'
  match '/my_events', to: 'static_pages#my_events', via: 'get'
  match '/news',    to: 'articles#index',       via: 'get'
  match '/approve_reviews', to: 'reviews#approve', via: 'get'
  match '/mentoring', to: 'mentorships#index',  via: 'get'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/12345abcsecret', to: 'users#school_correct', via: 'get'

end
