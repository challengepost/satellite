Satellite.configure do |config|

  # Required
  #
  # Configure provider and arguments for OmniAuth middleware
  config.omniauth :devpost,
    Rails.application.secrets.omniauth_provider_key,
    Rails.application.secrets.omniauth_provider_secret,
    provider_ignores_state: false

  # Optional
  #
  # Override default Warden Configuration
  # config.warden do |warden|
  #   warden.default_strategies :satellite
  #   warden.default_scope = :satellite
  #   warden.failure_app = Satelitte::SessionsController.action(:failure)
  # end
  #
  # Set the user class serialized in session and instantiated
  # as current_satellite_user and current_user if found
  # config.user_class            = User
  #
  # Set the anonymous user class instantiated as current_user
  # when no user is serialized in session
  # config.anonymous_user_class  = AnonymousUser
  #
  # Controllers will attempt to authenticate user by default
  # config.enable_auto_login     = true
end
