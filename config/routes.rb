Rails.application.routes.draw do

  # resources :user_sessions, only: [:new, :create]
  
  get '/users/sign_in' => "user_sessions#new", as: "sign_in"
  post '/users/sign_in' => "user_sessions#create"
  delete '/users/sign_out' => "user_sessions#destroy", as: "sign_out"
  get '/users/preferences' => "users#edit", as: "preferences"
  get "/users/:id/welcome/:tok" => "users#welcome", as: "welcome"

  resources :users do
    put :confirm, on: :member
  end
  
end
