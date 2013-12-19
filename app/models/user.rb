class User
  include HkNames
  include Her::PaginatedModel

  use_api DROOM
  collection_path "/api/users"
  root_element :user
  request_new_object_on_build true

  after_create :assign_to_associates

  def new?
    uid.nil?
  end

  def associates
    @associates ||= []
  end
  
  def associates=(these)
    @associates = these
  end

  def self.new_with_defaults
    self.new({
      uid: nil,
      title: "",
      given_name: "",
      family_name: "",
      chinese_name: "",
      email: "",
      phone: "",
      password: "",
      permission_codes: "",
      defer_confirmation: true
    })
  end

  def self.from_credentials(uid, token)
    Rails.logger.debug "<== Authenticating user with #{uid}, #{token}"
    begin
      self.get "/api/users/#{uid}/authenticate", token: token
    rescue JSON::ParserError
      nil
    end
  end

  def send_confirmation_message!
    self.assign_attributes send_confirmation: true
    self.save
  end

  def sign_out!
    # auth token is passed in request headers as with other api calls
    # so this should be enough to invalidate the session of the current user
    self.class.put "/api/users/deauthenticate"
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
  
  def image
    images[:standard]
  end
  
  def icon
    images[:icon]
  end

  def thumbnail
    images[:thumbnail]
  end
  
protected
    
  # We can't create associations with this user object until it has a uid, which for a new user
  # requires it to be saved first. For nested inline creation that means deferring assignment
  # until after user creation. To assign this user, push objects into its @associates array and
  # make sure they respond to user= (eg by including the HasDroomUser concern).
  #
  # The actual assignment happens in this after_save callback.
  #
  def assign_to_associates
    Rails.logger.debug "==>  #{self.class}#assign_to_associates"
    associates.each do |ass|
      ass.user = self
    end
  end

end
