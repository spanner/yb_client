# Consolidating the business of application-having.

module HasApplication
  extend ActiveSupport::Concern

  included do
    scope :with_application, -> { where('application_id IS NOT NULL AND application_id <> ""') }
    scope :without_application, -> { where('application_id IS NULL OR application_id = ""') }
  end

  def application
    Application.find(application_id)
  end
  
  def application?
    application_id && application
  end
  
end