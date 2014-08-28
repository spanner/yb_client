# Consolidating the business of page-having.

module HasPage
  extend ActiveSupport::Concern

  def page
    Page.find(page_id)
  end

  def page?
    !!page
  end

  def publication
    page.publication if page?
  end
  
  def publish!
    page.publish!
  end
  
end