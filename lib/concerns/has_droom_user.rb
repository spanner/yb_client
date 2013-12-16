module HasDroomUser
  extend ActiveSupport::Concern

  included do
    attr_accessor :newly_accepted
    
    scope :accepted, -> {
      where("accepted_at IS NOT NULL")
    }

    scope :unaccepted, -> {
      where("accepted_at IS NULL")
    }

    scope :invited, -> {
      where("invited_at IS NOT NULL")
    }

    scope :uninvited, -> {
      where("invited_at IS NULL")
    }
  end

  def invited?
    invited_at?
  end

  def uninvited?
    !invited?
  end

  def accepted?
    accepted_at?
  end

  def unaccepted?
    !accepted?
  end
  
  def invite!
    if droom_user?
      # if droom_user.unconfirmed?
      #   droom_user.send_confirmation_message!
      # end
      #TODO: configurable mailer class
      if invitation = GapMailer.send("invitation_to_#{self.class.to_s.downcase}".to_sym, self)
        if invitation.deliver
          self.update_column :invited_at, Time.zone.now
        end
      end
    end
  end

  def accept!
    unless accepted?
      self.update_column :accepted_at, Time.zone.now
      self.newly_accepted = true
    end
  end

  def newly_accepted?
    !!newly_accepted
  end

  def droom_user
    begin
      if droom_user_uid
        DroomClient::User.find(droom_user_uid)
      end
    rescue
      Rails.logger.warn "Screener #{self.id} has a user uid that corresponds to no m data room user. Perhaps someone has been deleted? Ignoring."
      nil
    end
  end

  # The only time +droom_user_attributes=+ would be called is during the creation of a new droom_user object.
  #
  def droom_user_attributes=(attributes)
    Rails.logger.warn "setting droom_user_attributes = #{attributes}"
    droom_user = DroomClient::User.new_with_defaults
    droom_user.assign_attributes(attributes)
    # We assign this object to the user with either screener= or interviewer=
    # Upon successful creation this will trigger the after_save callback that
    # assigns the user back to the object, by then with its uid in place.
    droom_user.send "#{self.class.to_s.downcase}=".to_sym, self
    droom_user.save
  end

  # +droom_user=+ will be called in two situations: during a compound save with an existing droom_user object, 
  # or during the after_save callback of a newly created droom_user with that object.
  # If we are persisted and not otherwise changed, we assume the latter case and save ourselves. It shouldn't
  # do any harm if unnecessary. Otherwise we assume that the controller is handling persistence and merely assign.
  #
  def droom_user=(droom_user)
    also_save = self.persisted? && !self.changed?
    self.droom_user_uid = droom_user.uid
    self.save if also_save
  end
  
  def droom_user?
    droom_user_uid? && droom_user
  end
  
  def confirmed?
    !!droom_user.confirmed if droom_user
  end

  def unconfirmed?
    !confirmed?
  end
  
  def send_confirmation_message!
    droom_user.send_confirmation_message! if droom_user
  end

  def status
    invited? ? accepted? ? "accepted" : "invited" : "uninvited"
  end
  
  def name
    droom_user.name if droom_user
  end

  def formal_name
    droom_user.formal_name if droom_user
  end

  def icon
    droom_user.icon if droom_user
  end

  def email
    droom_user.email if droom_user
  end
  
  def user
    DroomClient::User.where(uid: droom_user_uid).first if droom_user_uid?
  end
  
end