class Note
  include PaginatedHer::Model
  belongs_to :person, foreign_key: :person_uid
  
  def self.default_attributes
    {title: "", text: ""}
  end
  
  def author
    CdbClient.user_class.find(created_by_uid) if CdbClient.user_class?
  end

  def date
    DateTime.parse(created_at)
  end

end
