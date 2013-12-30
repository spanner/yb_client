Rails.application.routes.draw do

  mount CdbClient::Engine => "/cdb_client"
end
