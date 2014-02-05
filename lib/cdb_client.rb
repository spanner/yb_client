require 'settingslogic'
require 'request_store'
require 'dalli-elasticache'
require 'cdb_client/engine'

module CdbClient
  class AuthRequired < StandardError; end
  
end
