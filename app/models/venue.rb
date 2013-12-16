class Venue
  include Her::PaginatedModel

  use_api DROOM
  collection_path "/api/venues"
  root_element :venue
  request_new_object_on_build true

  def self.for_selection
    self.all.sort_by(&:name).map{|venue| [venue.name, venue.slug]}
  end

  def self.new_with_defaults
    self.new({
      name: "",
      address: ""
    })
  end

end
