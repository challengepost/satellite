RSpec.configure do |config|
  config.include Omniauth::Mock
  config.include Omniauth::SessionHelpers, type: :feature
  config.include Warden::ControllerHelpers, type: :controller
end
OmniAuth.config.test_mode = true
