Qb::Application.routes.draw do
  
  resources :questions do
    collection do
      post 'import'
    end
  end

  resources :tests do 
    member do
      get 'sample'
      get 'conduct'
      post 'conduct'
    end
  end

  delete '/attachments/:id' => 'attachments#delete'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users, :only => [:show, :index]
  get '/questions/judge/finalize/:id'=> 'questions#finalize'
end
