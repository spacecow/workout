Workout::Application.routes.draw do
  match '/delayed_job' => DelayedJobWeb, anchor:false

  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'
  resources :sessions, :only => [:new, :create, :destroy]
  resources :users, :only => [:show,:edit,:update]

  resources :training_types, :only => [:show,:index]

  resources :days, :only => :show
  resources :posts, :only => [:create,:index,:edit,:update,:destroy] do
    resources :comments, :only => [:create,:update,:destroy]
  end
  resources :current_states, :only => [:create,:update, :destroy]

  resources :noticements, :only => :index do
    member do
      put 'read'
    end
  end

  match "/stats/charts" => "stats#charts"
  match "/stats/toplists" => "stats#toplists"

  get 'welcome' => 'posts#index'
  root :to => 'posts#index'
end
