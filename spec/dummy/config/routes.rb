Rails.application.routes.draw do

  mount YbClient::Engine => "/yb_client"
end
