module Satellite
  class Configuration
    include ActiveSupport::Configurable

    config_accessor :provider

    config_accessor :omniauth_args do
      []
    end

    config_accessor :provider_root_url

    config_accessor :warden_config_blocks do
      []
    end

    config_accessor :enable_auto_login do
      true
    end

    config_accessor :user_class do
      User = Class.new{include Satellite::User}
    end

    config_accessor :anonymous_user_class do
      AnonymousUser = Class.new{include Satellite::AnonymousUser}
    end

    def enable_auto_login?
      !!self.enable_auto_login
    end

    def omniauth(provider, *args)
      self.provider = provider
      self.omniauth_args = args
    end

    def warden(&block)
      self.warden_config_blocks << block
    end

    def provider
      config.provider || (raise ConfigurationError.new("You must configure Satellite omniauth"))
    end

    def provider_root_url=(url)
      URI.parse(url)
      config.provider_root_url = url
    rescue URI::Error
      raise ConfigurationError.new("Provider root url invalid")
    end

    def finalize!(app)
      @configured ||= begin
                        configure_omniauth!(app)
                        configure_warden!(app)
                        true
                      end
    end

    private

    def configure_omniauth!(app)
      config = self
      app.middleware.use OmniAuth::Builder do |builder|
        provider config.provider, *config.omniauth_args
      end
    end

    def configure_warden!(app)
      app.middleware.use Warden::Manager do |warden|
        warden.default_strategies :satellite
        warden.default_scope = :satellite
        warden.failure_app = Satellite::SessionsController.action(:failure)
        warden_config_blocks.each {|block| block.call warden }
      end
    end
  end
end
