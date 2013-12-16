module DroomClient
  class Engine < ::Rails::Engine
    isolate_namespace DroomClient

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end
    
    initializer "droom_client.integration" do
      ActiveSupport.on_load :action_controller do
        include DroomClient::Authentication
      end
    end

  end
end
