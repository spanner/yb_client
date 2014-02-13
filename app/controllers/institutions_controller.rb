class InstitutionsController < ApplicationController
  respond_to :json
  layout false
  before_filter :get_institutions, only: [:index]

  def index
    respond_with @institutions
  end

  protected
  
  def get_institutions
    if params[:active]
      @institutions = Institution.active_for_selection(params[:country_code])
    else
      @institutions = Institution.for_selection(params[:country_code])
    end
  end

end
