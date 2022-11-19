Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/login', to: 'auth#create'   
      post '/login_facebook', to: 'auth#create_facebook_user'
      post 'create_brand', to: 'brands#create'
      get '/current_user', to: 'users#current_user'
      get '/brand_connetions', to: 'connections#show_brand_connections'
      post '/create_conexion', to: 'connections#create'
      get '/current_user_brand', to: 'users#current_user_brand'
      get '/page_facebook', to: "facebook#page_facebook_data"
      get '/page_facebook_profile', to: "facebook#page_profile_data"
      get '/test', to: "connections#test"
      delete '/connection_delete', to: "connections#destroy"

      resources :messages, only: [:index, :create]
      resources :users, only: [:index, :create]
      resources :chatrooms, only: [:index, :create, :show]
      resources :blog, only: [:index]
    end
    namespace :v1 do
      post '/register', to: 'users#create'
      post '/register_facebook', to: 'users#create_facebook_user'
    end
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
