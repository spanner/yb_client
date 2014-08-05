class Application
  include PaginatedHer::Model

  use_api CAP
  collection_path "/api/applications"
  belongs_to :round

  after_save :decache

  def self.new_with_defaults(attributes={})
    Application.new({
      
    }.merge(attributes))
  end

  protected

  def decache
    $cache.flush_all if $cache
  end

end
