module Satellite
  module ControllerExtensions
    extend ActiveSupport::Concern

    included do
      helper_method :current_user
      helper_method :user_signed_in?
    end

    def warden
      request.env['warden']
    end

    def current_user
      @current_user ||= current_satellite_user || anonymous_user
    end

    def current_satellite_user
      warden.authenticate(scope: :satellite)
    end

    def current_user?
      @user && @user == current_user
    end

    def user_signed_in?
      current_user.registered?
    end

    def auth_provider_path
      "/auth/#{Satellite.configuration.provider}"
    end

    def authenticate_user!
      return true if skip_satellite_authentication?
      return true if user_signed_in?

      if enable_auto_login?
        session[:return_to] = request.url
        redirect_to auth_provider_path
      else
        redirect_to after_sign_out_url,
          alert: 'You need to sign in for access to this page.'
      end
    end

    def authenticate_user?
      enable_auto_login? && cookies[:user_uid].present?
    end

    def sign_out
      return unless user_signed_in?

      warden.logout(:satellite)
      @current_user = anonymous_user
    end

    def valid_session?
      current_user.provider_key?([Satellite.configuration.provider, cookies[:user_uid]])
    end

    def after_sign_in_url
      return_to_url || root_url
    end

    # ensure path only endpoint retrieved from session to protect offsite redirect
    def return_to_url
      URI.parse(session.delete(:return_to)).path rescue nil
    end

    def after_sign_out_url
      if Satellite.configuration.enable_auto_login?
        failure_url
      else
        root_url
      end
    end

    def enable_auto_login?
      Satellite.configuration.enable_auto_login?
    end

    def skip_satellite_authentication?
      !!@skip_satellite_authentication
    end

    private

    def anonymous_user
      @anonymous_user ||= Satellite.configuration.anonymous_user_class.new
    end
  end
end
