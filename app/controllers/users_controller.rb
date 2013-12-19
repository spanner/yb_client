class UsersController < ApplicationController
  respond_to :json
  before_filter :get_users, only: [:index]
  before_filter :get_user, only: [:update]

  # User-creation is always nested. 
  # Our usual purpose here is to list suggestions for the administrator choosing interviewers or screening judges
  #
  def index
    respond_with @users.to_a
  end
  
  # ...but we can also confirm user accounts on arrival to save people a round trip. None of this will happen
  # unless they are signed in as a user who can do that in the data room (which usually means they have to be
  # signed in as this user).
  #
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
    @user = DroomUser.find(params[:id])
    Rails.logger.warn "@user: #{@user.inspect} for id #{params[:id]}"
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

