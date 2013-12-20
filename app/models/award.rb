class Award
  include Her::PaginatedModel
  belongs_to :person
  belongs_to :institution
end
