class Tag
  include PaginatedHer::Model
  use_api CDB
  collection_path "/api/tags"
end
