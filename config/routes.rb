DroomClient::Engine.routes.draw do

  # resources :user_sessions, only: [:new, :create]
  
  get '/users/sign_in' => "droom_client/user_sessions#new", as: "sign_in"
  post '/users/sign_in' => "droom_client/user_sessions#create"
  delete '/users/sign_out' => "droom_client/user_sessions#destroy", as: "sign_out"

end
