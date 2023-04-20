Rails.application.routes.draw do
  root "manipulators#user_register"
  resources :pictures
  resources :manipulators, :only => [:index, :update, :destroy] do
    collection do
      get 'user_register'
      post 'do_register'
      get 'user_login'
      get 'manager_login'
      post 'do_login'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
