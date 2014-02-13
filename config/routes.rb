Rails.application.routes.draw do

  # Institution-pickers are repopulated when a country is chosen.
  get "/cdb/institutions/:country_code" => "institutions#index", :as => 'country_institutions', :defaults => {:format => :json}
  get "/cdb/institutions/:country_code" => "institutions#index", :as => 'country_institutions', :defaults => {:format => :json}
  
end
