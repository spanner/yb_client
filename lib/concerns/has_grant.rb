# Consolidating the business of grant-having.

module HasGrant
  extend ActiveSupport::Concern

  included do
    scope :without_grant, -> { where('grant_id IS NULL OR grant_id = ""') }
  end

  def grant
    Grant.find(grant_id) if grant_id?
  end
  
  def grant?
    grant_id? && !!grant
  end
  
  def grant_type
    grant.grant_type if grant
  end
  
  def institutions
    grant.institutions if grant
  end
  
  def people
    grant.people if grant
  end

end