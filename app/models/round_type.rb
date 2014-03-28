class RoundType
  include PaginatedHer::Model

  use_api CAP
  collection_path "/api/round_types"

  after_save :decache

  protected

  def decache
    $cache.flush_all if $cache
  end

end
