class Institution
  include PaginatedHer::Model
  use_api CDB

  belongs_to :country, foreign_key: :country_code

  # *for_selection* returns a set of [name, id] pairs suitable for use as select options.
  def self.for_selection(country_code=nil)
    if country_code.present?
      insts = self.where(:country_code => country_code)
    else
      insts = self.all
    end
    insts.sort_by(&:normalized_name).map{|inst| [inst.normalized_name, inst.code] }
  end

  def self.active_for_selection(country_code=nil)
    if country_code.present?
      insts = self.where(:country_code => country_code, active: true)
    else
      insts = self.where(active: true)
    end
    insts.sort_by(&:normalized_name).map{|inst| [inst.normalized_name, inst.code] }
  end

  ## Output formatting
  #
  # The prepositionishness of names like "University of Cambridge" requires us to prepend a 'the'
  # when in object position. Eg. studying at the University of Cambridge vs. studying at Oxford University.
  # 
  def definite_name(prefix="the")
    puts "deriving definite_name of #{self}"
  
    if self.name =~ /of/i
      "#{prefix} #{self.name}"
    else
      self.name
    end
  end


end
