class InstitutionsController < ApplicationController
  respond_to :json
  layout false
  before_filter :get_institutions, only: [:index]

  def index
    respond_with @institutions
  end

  def get_institutions
    @institutions = Institution.for_selection(params[:country_code])
  end

end
