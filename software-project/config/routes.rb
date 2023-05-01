Rails.application.routes.draw do
  resources :songs
  resources :song_types
  root "song_types#index"
  resources :pictures
  resources :manipulators, :only => [:index, :update, :destroy] do
    collection do
      get 'user_register'
      post 'do_register'
      get 'user_login'
      get 'manager_login'
      post 'do_login'
      get 'logout'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
