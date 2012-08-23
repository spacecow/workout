Workout::Application.routes.draw do
  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'
  resources :sessions, :only => [:new, :create, :destroy]
  resources :users, :only => :show

  resources :training_types, :only => [:show,:index]

  resources :posts, :only => [:new,:create,:index,:edit,:update,:destroy]

  get 'welcome' => 'posts#index'
  root :to => 'posts#index'
end
