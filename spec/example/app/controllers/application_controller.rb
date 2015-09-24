class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!, if: :enable_auto_login?

  def authenticate_admin_user!
    return true if skip_satellite_authentication?
    return true if current_user.admin?
    raise Satellite::AccessDenied.new("Not authorized as an admin user")
  end

  rescue_from Satellite::AccessDenied do |exception|
    redirect_to failure_url message: exception.message
  end
end

