class Person
  include HkNames
  include PaginatedHer::Model
  use_api CDB
  collection_path "/api/people"
  primary_key :uid

  has_many :awards
  has_many :tags
  has_many :notes
  belongs_to :country, foreign_key: :country_code
  belongs_to :graduated_from, foreign_key: :graduated_from_code, class_name: "Institution"

  after_save :decache

  class << self
    def for_selection
      Person.all.sort_by(&:name).map{|p| [p.name, p.uid] }
    end
  
    def new_with_defaults
      Person.new({
        uid: "",
        title: "",
        family_name: "",
        given_name: "",
        chinese_name: "",
        award_type_code: "",
        pob: "",
        dob: nil,
        post: "",
        department: "",
        employer: "",
        country_code: "HKG",
        email: "",
        phone: "",
        mobile: "",
        correspondence_address: "",
        hidden: false,
        blacklisted: false,
        graduated_from_code: "",
        graduated_year: "",
        msc_year: "", 
        mphil_year: "",
        phd_year: ""
      })
    end
  end
  
  def invitable?
    email?
  end
  
  def to_param
    uid
  end

  def ias?
    awards.any? { |a| a.award_type_code == 'ias'}
  end

  def srf?
    awards.any? { |a| a.award_type_code == 'srf'}
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

  def thumb
    images[:thumb]
  end

  def icon
    images[:icon]
  end
  
  def pronoun
    if gender? && gender == "f"
      I18n.t(:she)
    else
      I18n.t(:he)
    end
  end

  protected
  
  def decache(and_associates=true)
    if $cache
      path = self.class.collection_path
      $cache.delete path
      $cache.delete "#{path}/#{self.to_param}"
      if and_associates
        self.awards.each do |a|
          a.send(:decache, false)
        end
      end
    end
  end
  
end
