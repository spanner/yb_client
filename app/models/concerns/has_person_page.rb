# Consolidating the business of page-having.

module HasPersonPage
  extend ActiveSupport::Concern

  def person_page
    PersonPage.find(person_page_id)
  end

  def person_page?
    person_page_id? && !!person_page
  end

end