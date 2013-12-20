class Person
  include HkNames
  include Her::PaginatedModel
  primary_key :uid

  has_many :awards
  has_many :tags
  belongs_to :country, foreign_key: :country_code

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
  
  def image
    images[:standard]
  end

  def thumbnail
    images[:thumbnail]
  end

  def icon
    images[:icon]
  end
  
  def user
    User.for(self)
  end

end
