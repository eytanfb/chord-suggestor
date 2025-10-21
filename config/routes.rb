Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # define home controller
  root 'home#index'

  post '/home/update', to: 'home#update', as: 'update_home'

  resources :progression, only: [] do
    collection do
      post :update
    end
  end
end
