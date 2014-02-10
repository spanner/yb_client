# Consolidating the business of institution-having.

module HasInstitution
  extend ActiveSupport::Concern

  included do
    after_save :find_or_create_named_institution
    scope :without_institution, -> { where('institution_code IS NULL OR institution_code = ""') }
  end

  def institution
    Institution.find(institution_code) if institution_code?
  end
  
  def institution_name
    if @institution_name.present?
      @institution_name
    elsif institution
      institution.name
    end
  end
  
  def institution_name=(name)
    @institution_name = name
  end
  
  protected

  def find_or_create_named_institution
    if @institution_name.present?
      if existing = Institution.where(name: @institution_name, country_code: country_code).first
        self.update_column :institution_code, existing.code
      else
        created = Institution.create(name: @institution_name, country_code: country_code)
        self.update_column :institution_code, created.code
      end
    end
  end
    
end