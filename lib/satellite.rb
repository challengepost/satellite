require "satellite/version"

module Satellite
  extend self

  autoload :Configuration, "satellite/configuration"
  autoload :ControllerExtensions, "satellite/controller_extensions"
  autoload :User, "satellite/user"
  autoload :UserCookie, "satellite/user_cookie"
  autoload :JWTUserDecoder, "satellite/jwt_user_decoder"
  autoload :AnonymousUser, "satellite/anonymous_user"

  def configure
    yield configuration
  end

  def configuration
    @configuration ||= Satellite::Configuration.new
  end

  def finalize_configuration!(app)
    configuration.finalize!(app)
  end

end

require "satellite/engine"
require "satellite/exceptions"
require "satellite/warden_strategy"
require "satellite/database_uri"
