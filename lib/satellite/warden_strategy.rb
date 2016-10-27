require 'warden'

# Satellite warden strategy will authenticate user for a
# 'satellite' client app for the configured provider,
# which for our purposes is likely to be 'devpost'
#
module Satellite
  class WardenStrategy < Warden::Strategies::Base

    # cookies[:production_user_jwt] provided when logged in on platform app
    # env['omniauth.auth'] provided when completed omniauth callback
    #
    def valid?
      user_cookie.present? && env['omniauth.auth']
    end

    def authenticate!
      user = user_class.find_or_create_with_omniauth(env['omniauth.auth'])
      if valid_session?(user)
        success! user
      else
        Rails.logger.info "Warden failure!!! #{env['omniauth.auth'].inspect}" if defined?(Rails)
        fail!("Could not log in")
      end
    end

    private

    def cookies
      env['action_dispatch.cookies']
    end

    def user_cookie
      @user_cookie ||= Satellite::UserCookie.new(cookies)
    end

    def valid_session?(user)
      user && user.provider_key?(cookie_provider_key)
    end

    def cookie_provider_key
      [Satellite.configuration.provider, user_cookie.to_cookie]
    end

    def user_class
      Satellite.configuration.user_class
    end
  end
end

Warden::Strategies.add(:satellite, Satellite::WardenStrategy)

Warden::Manager.serialize_into_session do |user|
  [user.class.name, user.id]
end

Warden::Manager.serialize_from_session do |serialized|
  class_name, id = serialized
  class_name.constantize.find(id)
end
