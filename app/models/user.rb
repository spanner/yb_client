class User
  include HkNames
  include Her::PaginatedModel

  use_api DROOM
  collection_path "/api/users"
  root_element :user
  request_new_object_on_build true

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
    self.get("/api/users/#{uid}/authenticate", token: token)
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

  def person
    Person.find(person_uid)
  end
  
  def person?
    !!person
  end
  
  def permitted?(key)
    permission_codes.include?(key)
  end
  
  def allowed_here?
    permitted?("#{Settings.service_name}.login")
  end

  def admin?
    permitted?("#{Settings.service_name}.admin")
  end
  

protected

  def ensure_uid!
    self.uid = SecureRandom.uuid if self.uid.blank?
  end
  
  def set_defer_confirmation
    self.defer_confirmation = true
  end
  

end
