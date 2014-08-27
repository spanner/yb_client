class Publication
  include PaginatedHer::Model
  use_api YB
  collection_path "/api/people/:person_uid/publications"
  belongs_to :page
  
  def date
    DateTime.parse(created_at)
  end
  
  def current?
    !!current
  end
end

