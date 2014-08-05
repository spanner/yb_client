class Application
  include PaginatedHer::Model

  use_api CAP
  collection_path "/api/applications"
  belongs_to :round

  after_save :decache

  protected

  def decache
    $cache.flush_all if $cache
  end

end
