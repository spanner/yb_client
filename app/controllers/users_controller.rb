class UsersController < ApplicationController
  respond_to :html, :json
  before_filter :get_users, only: [:index]
  before_filter :get_user, only: [:edit, :update]
  layout :no_layout_if_pjax

  # User-creation is always nested. 
  # Our usual purpose here is to list suggestions for the administrator choosing interviewers or screening judges
  #
  def index
    respond_with @users.to_a
  end
  
  # But people can change their settings, or confirm their account.
  #
  def edit
    respond_with @user
  end
  
  def update
    authorize! :update, @user
    @user.assign_attributes(user_params)
    @user.save
    if params[:destination].present?
      redirect_to params[:destination]
    else
      redirect_to root_url
    end
  end

protected

  def get_user
    if params[:id].present? && can?(:manage, User)
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    Rails.logger.warn "@user: #{@user.inspect}"
  end

  def get_users
    @users = DroomUser.all
    @show = params[:show] || 20
    @page = params[:page] || 1
    unless @show == 'all'
      @users = @users.page(@page).per(@show) 
    end
    @users
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :confirmed)
  end

end

