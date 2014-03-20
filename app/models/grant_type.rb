class GrantType
  include PaginatedHer::Model
  use_api CDB
  collection_path "/api/grant_types"

  def self.for_selection
    GrantType.all.sort_by(&:name).map{|grt| [grt.short_name, grt.code] }
  end
end
