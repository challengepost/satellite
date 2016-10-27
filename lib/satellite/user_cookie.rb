module Satellite
  class UserCookie
    COOKIE_NAME = "#{Rails.env}_user_jwt"

    attr_reader :cookies

    delegate :present?, to: :to_cookie

    def initialize(cookies)
      @cookies = cookies
    end

    def to_cookie
      cookies[cookie_name]
    end

    def cookie_name
      COOKIE_NAME
    end
  end
end
