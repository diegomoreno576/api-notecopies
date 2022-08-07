Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/login', to: 'auth#create'
      resources :messages, only: [:index, :create]
      resources :users, only: [:index, :create]
      resources :chatrooms, only: [:index, :create, :show]
      resources :blog, only: [:index]
    end
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
