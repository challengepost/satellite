module Satellite
  class JWTUserDecoder
    attr_reader :token

    def initialize(token)
      @token = token
    end

    def payload
      @payload ||= ::JWT.decode(token, Satellite.configuration.jwt_secret_key_base).first
    end

    def user
      ::User.find_by(uid: user_uid)
    end

    def user_uid
      payload["id"]
    end
  end
end
