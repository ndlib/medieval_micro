class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  layout :choose_layout

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :is_masquerading?

  rescue_from CanCan::AccessDenied do |exception|
    logger.warn( <<-END
 CanCan::AccessDenied
      Time: #{Time.now}
       URI: #{request.request_uri}
        IP: #{request_ip}
 API Token: #{api_token}
      User: #{current_user.to_s}
   Message: #{exception.message}
END
    )
    render 'public/401.html', :status => :unauthorized, :layout => false
  end

  private

  def is_admin?
    current_user.has_role?('administrators')
  end

  def current_user
    is_masquerading? ? user_the_masquerade : super
  end

  def previous_page
    request.referrer || root_path
  end

  def user_the_masquerade
    User.find_by_username(session[:user_the_masquerade])
  end

  def is_masquerading?
    !session[:user_the_masquerade].blank?
  end

  def deny_action
    redirect_to new_user_session_path, alert: "You must be logged in to perform this action"
  end

  def require_login
    store_location
    deny_action unless current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def stored_location_for(resource_or_scope)
    nil
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:return_to] || root_path
  end
end
