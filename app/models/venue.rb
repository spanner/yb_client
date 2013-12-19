class Venue
  include Her::PaginatedModel

  use_api DROOM
  collection_path "/api/venues"
  root_element :venue
  request_new_object_on_build true

  after_create :assign_to_associates

  @associates = []
  attr_accessor :associates

  def self.for_selection
    self.all.sort_by(&:name).map{|venue| [venue.name, venue.slug]}
  end

  def self.new_with_defaults
    self.new({
      name: "",
      address: ""
    })
  end

protected
  
  # We can't create associations with this venue object until it has a slug, so it has to be
  # done in this after_create callback. See User for more detail.
  #
  def assign_to_associates
    associates.each do |ass|
      ass.venue = self
    end
  end

end
