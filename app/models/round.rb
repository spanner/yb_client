class Round
  include PaginatedHer::Model
  include HasGrant

  use_api CAP
  collection_path "/api/rounds"
  has_many :applications

  after_save :decache

  def self.new_with_defaults(attributes={})
    Round.new({
      
    }.merge(attributes))
  end

  protected

  def decache
    $cache.flush_all if $cache
  end

end
