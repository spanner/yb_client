class Note
  include PaginatedHer::Model
  use_api CDB
  belongs_to :person, foreign_key: :person_uid
  collection_path "people/:person_uid/notes"
  
  def self.new_with_defaults(attributes={})
    self.new({
      title: "", 
      text: ""
    }.merge(attributes))
  end
  
  def date
    DateTime.parse(created_at)
  end

end
