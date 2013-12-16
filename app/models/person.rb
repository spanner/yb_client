class Person
  include HkNames
  include Her::PaginatedModel
  primary_key :uid

  has_many :awards
  has_many :tags
  belongs_to :country, foreign_key: :country_code

  # Associations between remote and local models are difficult to establish
  # and never work very well, so we handle that directly.

  def page
    Page.where(person_uid: uid).first
  end

  def page?
    !!page
  end

  def publications
    page.publications if page?
  end

  def ias?
    !!ias
  end

  def srf?
    !!srf
  end

  def status
    if ias?
      "ias"
    elsif srf?
      "srf"
    else
      "scholar"
    end
  end

end
