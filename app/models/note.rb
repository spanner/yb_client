class Note
  include PaginatedHer::Model
  use_api CDB
  belongs_to :person, foreign_key: :person_uid
  collection_path "/api/people/:person_uid/notes"
  
  after_save :decache
  
  def self.new_with_defaults(attributes={})
    self.new({
      title: "", 
      text: ""
    }.merge(attributes))
  end
  
  def date
    DateTime.parse(created_at)
  end

  protected
  
  def decache(and_associates=true)
    if $cache
      path = self.class.collection_path
      $cache.delete path
      $cache.delete "#{path}/#{self.to_param}"
      self.person.send(:decache, false) if and_associates && self.person
    end
  end

end
