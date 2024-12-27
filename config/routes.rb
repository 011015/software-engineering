Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  mount ActionCable.server => '/cable'
  root "song_types#index"
  resources :reports, :only => [:index, :update, :destroy]
  resources :songs do
    resources :images, :only => [:create, :destroy]
    resources :audios, :only => [:create, :destroy]
    resources :comments, :only => [:create, :destroy] do
      resources :comments, :only => [:create]
      resources :reports, :only => [:create]
    end
    resources :collects, :only => [:create, :destroy]
  end
  resources :song_types, :only => [:index, :new, :create, :destroy]
  resources :manipulators, :only => [:index, :update, :destroy] do
    collection do
      get 'user_register'
      post 'do_register'
      get 'user_login'
      get 'manager_login'
      post 'do_login'
      get 'logout'
      get 'personal_info'
      delete 'delete_avatar', to: 'manipulators#delete_avatar'
    end
  end
  resources :notices, :only => [:update, :destroy]
  delete 'collects/:id', to: 'collects#delete', as: 'delete_collect'
  get 'get_session_id', to: 'manipulators#session_id'
  get '*path', to: 'errors#not_found', via: :all
end
