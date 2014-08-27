require 'settingslogic'
require 'request_store'
require 'dalli-elasticache'
require 'yb_client/engine'

module YbClient
  class AuthRequired < StandardError; end
  
end
