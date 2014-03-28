Rails.application.routes.draw do

  mount CapClient::Engine => "/cap_client"
end
