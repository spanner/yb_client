require 'settingslogic'
require 'request_store'
require 'cdb_client/engine'

module CdbClient
  class AuthRequired < StandardError; end
  
  mattr_accessor :user_class
  
  class << self
    
    def user_class
      @@user_class ||= if defined?(Droom)
        "Droom::User".constantize
      elsif defined?(User)
        "User".constantize
      end
    end
    
    def user_class?
      !!user_class
    end

  end

end
