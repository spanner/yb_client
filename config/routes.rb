Rails.application.routes.draw do

  # Institution-pickers are repopulated when a country is chosen.
  get "/cdb/institutions/:country_code" => "institutions#index", :as => 'institutions', :defaults => {:format => :json}
  
end
