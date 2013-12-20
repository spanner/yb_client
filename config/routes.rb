Rails.application.routes.draw do

  # resources :user_sessions, only: [:new, :create]
  
  get '/users/sign_in' => "user_sessions#new", as: "sign_in"
  post '/users/sign_in' => "user_sessions#create"
  delete '/users/sign_out' => "user_sessions#destroy", as: "sign_out"

  resources :users, only: [:index, :edit, :update]
  get "/users/welcome/:id/:tok" => "users#welcome", as: "welcome"
  get '/users/confirm' => "users#confirm", as: "confirm"
  get '/users/preferences' => "users#edit", as: "preferences"
  
  
end
