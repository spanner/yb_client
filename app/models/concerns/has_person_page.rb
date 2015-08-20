# Consolidating the business of page-having.

module HasPersonPage
  extend ActiveSupport::Concern

  def person_page
    PersonPage.find(page_id)
  end

  def person_page?
    person_page_id? && !!person_page
  end

  def person_publication
    person_page.person_publication if person_page?
  end
  
  def publish!
    person_page.publish!
  end
  
end