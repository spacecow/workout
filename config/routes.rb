Workout::Application.routes.draw do
  resources :posts, :only => :index do
    collection do
      get :detail
    end
  end
  root :to => 'posts#index'
end
