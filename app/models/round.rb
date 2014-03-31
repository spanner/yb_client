class Round
  include PaginatedHer::Model
  include HasGrant

  use_api CAP
  collection_path "/api/rounds"

  belongs_to :round_type
  has_many :applications

  after_save :decache

  def self.new_with_defaults(attributes={})
    Round.new({
      
    }.merge(attributes))
  end

  def path
    parts = ['rounds']
    parts.push(round_type.slug) if round_type
    parts.push(slug)
    parts.join('/')
  end
  
  def open?
    applications_end && (closing_date > Time.now) && (!opening_date || opening_date < Time.now)
  end

  def opening_date
    Date.parse(start) if start?
  end
  
  def closing_date
    Date.parse(applications_end) if applications_end?
  end

  protected

  def decache
    $cache.flush_all if $cache
  end

end
