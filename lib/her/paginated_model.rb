## Remote resources
#
# cheat sheet:
#   RequestStore.store[:current_user] = User.find(...)
#   id = InterviewDay.first
#   dv = id.droom_venue
#
module Her
  module PaginatedModel
    extend ActiveSupport::Concern
    include Her::Model
    
    included do
      self.include_root_in_json true
    end
    
    module ClassMethods
      # We are overriding the standard collection with a pagination-respecting equivalent.
      # the parsed_data argument is given in a call from our PaginatedParser, which you can
      # find in /lib/her/middleware. All it does is to eat headers and add the :pagination 
      # key we are about to read.
      #
      def new_collection(parsed_data)
        initialize_collection(parsed_data)
      end

      def initialize_collection(parsed_data={})
        collection = Her::Model::Attributes.initialize_collection(self, parsed_data)
        if parsed_data[:pagination]
          Kaminari.paginate_array(collection, parsed_data[:pagination])
        else
          collection
        end
      end
      
    end
  end

end