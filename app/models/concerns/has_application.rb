# Consolidating the business of application-having.

module HasApplication
  extend ActiveSupport::Concern

  def application
    Application.find(application_id)
  end
  
  def application?
    application_id && application
  end
  
end