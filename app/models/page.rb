class Page
  include Her::JsonApi::Model
  use_api YB
  collection_path "/api/pages"
  has_one :publication

  def self.new_with_defaults(attributes={})
    page = Page.new({
      person_uid: nil,
      send_invitation: false,
      send_reminder: false,
      featured: false,
      featured_at: nil,
      blacklisted: false,
      invited_at: nil,
      reminded_at: nil,
      accepted_at: nil,
      name: "",
      slug: "",
      biog: "",
      currently: ""
    }.merge(attributes))
    page
  end
  
  def new_record?
    id.nil?
  end

  def featured_date
    DateTime.parse(featured_at)
  end
  
  def featured=(value)
    value = false if value == 'false'
    if value
      self.featured_at = Time.now
    else
      self.featured_at = nil
    end
  end
  
  def featured?
    !featured_at.nil?
  end
  
  def invited?
    !invited_at.nil?
  end

  def invitable?
    person.invitable?
  end

  def invited_date
    DateTime.parse(invited_at) if invited_at.present?
  end

  def accepted?
    !accepted_at.nil?
  end

  def accepted_date
    DateTime.parse(accepted_at).in_time_zone(Rails.application.config.time_zone) if accepted_at.present?
  end

  def reminded?
    !reminded_at.nil?
  end
  
  def remindable?
    invited? && !accepted?
  end

  def reminded_date
    DateTime.parse(reminded_at).in_time_zone(Rails.application.config.time_zone) if reminded_at.present?
  end
  
  def published?
    publication_id && !!publication
  end

  def reminded_to_publish?
    !reminded_to_publish_at.nil?
  end
  
  def remindable_to_publish?
    invited? && user && user.confirmed?
  end
  
  def reminded_to_publish_date
    DateTime.parse(reminded_to_publish_at).in_time_zone(Rails.application.config.time_zone) if reminded_to_publish_at.present?
  end
  
  def as_json(options={})
    {
      biog: biog,
      currently: currently,
      blacklisted: blacklisted?,
      hidden: hidden?,
      featured: featured?,
      featured_at: featured_at,
      slug: slug
    }
  end

end

