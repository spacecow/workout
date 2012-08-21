Workout::Application.routes.draw do
  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'
  resources :sessions, :only => [:new, :create, :destroy]
  resources :users, :only => :show

  resources :posts, :only => [:new,:create,:index]

  get 'welcome' => 'posts#index'
  root :to => 'posts#index'
end
