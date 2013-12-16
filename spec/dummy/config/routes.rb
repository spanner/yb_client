Rails.application.routes.draw do

  mount DroomClient::Engine => "/droom_client"
end
