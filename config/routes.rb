Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # define home controller
  root 'home#index'

  resources :home, only: %i[index] do
    collection do
      post :update
    end
  end

  resources :progression, only: [] do
    collection do
      post :update
    end
  end
end
