class Award
  include PaginatedAuthorizedHer::Model
  belongs_to :person
  belongs_to :institution
end
