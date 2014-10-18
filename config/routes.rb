Rails.application.routes.draw do
  resources :posts do
    get "hear"
    get "compile"
    get "compress"
    get "stop"
    get "resources/audiofiles/electronic/kick"
    get "resources/audiofiles/electronic/openhat"
  end
  root :to => "visitors#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  
end
