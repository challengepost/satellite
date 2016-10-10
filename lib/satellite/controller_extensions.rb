require "addressable/uri"

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
      "#{Satellite.configuration.path_prefix}/#{Satellite.configuration.provider}"
    end

    # Ex: /teams/auth/devpost
    def satellite_auth_provider_url
      uri = Addressable::URI.parse(Satellite.configuration.provider_root_url)
      uri.path = auth_provider_path
      uri.to_s
    end

    def authenticate_user!
      return true if skip_satellite_authentication?
      return true if user_signed_in?

      if enable_auto_login?
        session[:return_to] = Addressable::URI.parse(request.url).tap do |url|
          # use configured host instead of request host
          # prevents redirecting to proxied host
          url.host = root_url_host || request.host
        end.to_s
        redirect_to satellite_refresh_url
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
      return_to = session.delete(:return_to)
      return unless return_to

      Addressable::URI.parse(return_to).tap do |url|
        url.scheme = nil
      end.to_s
    end

    def after_sign_out_url
      if Satellite.configuration.enable_auto_login?
        satellite.failure_url
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

    def skip_satellite_authentication
      @skip_satellite_authentication = true
    end

    def root_url_host
      default_url_opts = Rails.application.config.action_controller.default_url_options
      default_url_opts[:host] if default_url_opts
    end

    private

    def satellite_refresh_url
      Addressable::URI.parse(Satellite.configuration.provider_root_url).tap do |url|
        url.path = "/auth/satellite_refresh"
        url.query_values = {
          return_to: satellite.refresh_url,
          auth_provider_url: satellite_auth_provider_url
        }
      end.to_s
    end

    def anonymous_user
      @anonymous_user ||= Satellite.configuration.anonymous_user_class.new
    end
  end
end
