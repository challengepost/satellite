module Satellite
  class UserCookie
    attr_reader :cookies

    delegate :present?, :blank?, to: :to_cookie

    def initialize(cookies)
      @cookies = cookies
    end

    def to_cookie
      cookies[cookie_name]
    end

    def cookie_name
      @cookie_name ||= [environment, "jwt"].compact.join("_")
    end

    def delete
      cookies.delete(cookie_name, domain: :all, httponly: true)
    end

    def valid_session?(user)
      return false unless user
      user && user.provider_key?(provider_key)
    end

    private

    def provider_key
      [Satellite.configuration.provider, jwt_user.user_uid]
    end

    def jwt_user
      Satellite::JWTUserDecoder.new(to_cookie)
    end

    def environment
      return nil if production_env?
      rails_env
    end

    def production_env?
      rails_env == "production"
    end

    def rails_env
      Satellite.configuration.env
    end
  end
end
