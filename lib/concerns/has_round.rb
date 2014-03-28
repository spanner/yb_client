# Consolidating the business of round-having.

module HasRound
  extend ActiveSupport::Concern

  included do
    scope :without_round, -> { where('round_id IS NULL OR round_id = ""') }
  end

  def round
    Round.find(round_id) if round_id?
  end
  
  def round?
    round_id? && !!round
  end
  
  def round_type
    round.round_type if round?
  end
  
  def applications
    round.applications if round?
  end
  
  def application_count
    round.application_count if round?
  end

end