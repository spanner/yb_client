class Publication
  include Her::JsonApi::Model
  use_api YB
  collection_path "/api/publications"
  belongs_to :page
  
  def date
    DateTime.parse(created_at)
  end
  
  def current?
    !!current
  end
end

