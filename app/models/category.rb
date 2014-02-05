class Category
  include PaginatedHer::Model
  use_api CDB
  collection_path "/api/categories"

  def self.for_selection
    Category.all.sort_by(&:name).map{|cat| [cat.name, cat.code] }
  end

end
