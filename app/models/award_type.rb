class AwardType
  include PaginatedHer::Model
  use_api CDB

  def self.for_selection
    AwardType.all.sort_by(&:name).map{|awt| [awt.short_name, awt.code] }
  end
end
