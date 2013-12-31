class Award
  include PaginatedHer::Model
  use_api CDB
  
  belongs_to :institution, foreign_key: :institution_code
  belongs_to :category, foreign_key: :category_code
  belongs_to :award_type, foreign_key: :award_type_code
  belongs_to :country, foreign_key: :country_code
  belongs_to :person, foreign_key: :person_uid
  
  def summary
    "##{record_no}: #{name} to #{person.name}"
  end
  
  def person
    Person.find(self.person_uid)
  end
end
