module DroomClient
  class User
    include DroomClient::HkNames
    include Her::PaginatedModel
    collection_path "/api/users"
    root_element :user
    request_new_object_on_build true
    # primary_key :uid

    before_create :set_defer_confirmation

    def self.new_with_defaults
      self.new({
        uid: "",
        title: "",
        given_name: "",
        family_name: "",
        email: "",
        phone: ""
      })
    end

    def self.from_credentials(uid, token)
      self.where(uid: uid, authentication_token: token).first
    end

    def send_confirmation_message!
      self.assign_attributes send_confirmation: true
      self.save
    end
  
    def unconfirmed?
      !!self.confirmed
    end

    def to_param
      uid
    end

    def permitted?(key)
      permission_codes.include?(key)
    end

  protected

    def ensure_uid!
      self.uid = SecureRandom.uuid if self.uid.blank?
    end
    
    def set_defer_confirmation
      self.defer_confirmation = true
    end
    

  end
end