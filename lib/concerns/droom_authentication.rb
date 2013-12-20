# Here we extract a small part of the authorize-or-redirect functionality normally 
# provided by devise or authlogic. No need for the full paraphernalia because we
# don't manage users here; only user sessions. All we have to do is consult the data 
# room and remember the response. As well as the local session we stash it in a cross-
# domain cookie for basic SSO support.
#
# The actual consultation is done by our User resource class.
#
# This is separated out as a concern in order that it can be shared between several 
# satellite applications. This and other shared functionality like the Her extensions 
# will end up in their own gem once it all settles down.

require 'droom_client/auth_cookie'

module DroomAuthentication
  extend ActiveSupport::Concern

  included do
    prepend_before_filter :authenticate_user
    helper_method :current_user
    helper_method :user_signed_in?
    rescue_from "DroomClient::AuthRequired", with: :redirect_to_login
  end

  def store_location!
    session["user_return_to"] = request.path
  end

  def use_stored_location_for(user)
    session.delete("user_return_to")
  end

  def stored_location_for(user)
    session["user_return_to"]
  end

  def default_location_for(user)
    root_path
  end

  def after_sign_in_path_for(user)
    path = use_stored_location_for(user) || default_location_for(user)
    path = root_path if path == users_sign_in_path
    path
  end
  
  def after_sign_out_path_for(user)
    root_path
  end
  
  def after_user_update_path_for(user)
    root_path
  end

protected
  
  ## Authentication filters
  #
  # Use in controllers to require various states of authentication.

  def authenticate_user!
    raise DroomClient::AuthRequired unless authenticate_user
  end

  def require_admin!
    user_signed_in? && current_user.admin?
  end

  def require_no_user!
    if user_signed_in?
      flash[:error] = I18n.t(:already_signed_in)
      redirect_to after_sign_in_path_for(current_user)
    end
  end

  def redirect_to_login(exception)
    store_location!
    flash[:alert] = I18n.t(:authentication_required)
    redirect_to sign_in_path
  end

  ## Stored Authentication
  # is always by a uid/auth_token pair. It can be given as params or in a cookie. Http auth
  # and http-options also possible but our focus is on API consumers at the moment.

  def authenticate_user
    RequestStore.store[:current_user] ||= authenticate_from_params || authenticate_from_cookie
  end
  
  def authenticate_from_params
    authenticate_with(params[:uid], params[:auth_token]) if params[:uid].present? && params[:auth_token].present?
  end
  
  # Auth is always remote, so that we also get single sign-out.
  # Note this returns user if found, false if none, allowing authenticate_user to try something else.
  #
  def authenticate_with(uid, auth_token)
    if user = User.from_credentials(uid, auth_token)
      sign_in(user)
    end
  end

  def current_user
    RequestStore.store[:current_user]
  end

  def user_signed_in?
    !!current_user
  end
  
  def sign_in(user)
    RequestStore.store[:current_user] = user
  end
  
  def sign_in_and_remember(user)
    sign_in(user)
    set_auth_cookie_for(user, Settings.auth.cookie_domain)
  end


  ## Domain cookies 
  # are used to provide simple SSO support. A shared secret is required to decode the cookie,
  # and then authentication is checked against the data room server.
  #
  # Cookie holds encoded array of [uid, auth_token]
  def authenticate_from_cookie
    cookie = DroomClient::AuthCookie.new(cookies)
    if cookie.valid?
      authenticate_with(cookie.uid, cookie.token)
    end
  end

  def set_auth_cookie_for(user, domain, remember=false)
    expires = Time.now + (Settings.auth.cookie_period || 1).days if remember
    DroomClient::AuthCookie.new(cookies).set(user, domain: domain, expires: expires)
  end
  
  def unset_auth_cookie(domain=nil)
    DroomClient::AuthCookie.new(cookies).unset(domain: domain)
  end

end