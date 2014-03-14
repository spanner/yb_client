class Note
  include PaginatedHer::Model
  use_api CDB
  collection_path "/api/notes"
  belongs_to :person, foreign_key: :person_uid

  after_save :decache
  after_destroy :decache

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
      Rails.logger.warn "xx  decache #{path}"
      $cache.delete path
      Rails.logger.warn "xx  decache #{path}/#{self.to_param}"
      $cache.delete "#{path}/#{self.to_param}"
      self.person.send(:decache, false) if and_associates && self.person
    end
  end

end
