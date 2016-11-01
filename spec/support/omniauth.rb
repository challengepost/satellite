module OmniAuthHelpers
  ::OmniAuth.config.logger = Logger.new('/dev/null')

  module Mock
    def mock_auth(credentials = default_auth_credentials)
      OmniAuth.config.mock_auth[:devpost] = case credentials
      when Symbol
        {}
      else
        OmniAuth.config.mock_auth[:devpost] = OmniAuth::AuthHash.new credentials
      end
    end

    def default_auth_credentials
      {
        "provider" => "devpost",
        "uid" => 144710,
        "info" => {
          "screen_name" => "bobloblaw",
          "email" => "bob@example.com",
          "first_name" => "Bob",
          "last_name" => "Loblaw"
        },
        "credentials" => {
          "token" => "8a32c87694496ac40bae6c959c5f267aa40d1dd7dcdfeb1847ba612926a05348",
          "expires_at" => 1403130221,
          "expires" => true
        },
        "extra" => {
          "raw_info" => {
            "id" => 144710,
            "first_name" => "Bob",
            "last_name" => "Loblaw",
            "email" => "bob@gmail.com",
            "role" => "admin",
            "screen_name" => "bob"
          }
        }
      }
    end

    def admin_auth_credentials
      default_auth_credentials
    end

    def nonadmin_auth_credentials
      default_auth_credentials.tap do |creds|
        creds['extra']['raw_info']['role'] = 'user'
      end
    end
  end

  module SessionHelpers
    extend ActiveSupport::Concern

    included do
      include ShowMeTheCookies
    end

    def mock_sso_auth(credentials = default_auth_credentials)
      auth = mock_auth(credentials)
      token = ::JWT.encode({ id: credentials["uid"] }, Satellite.configuration.jwt_secret_key_base)
      create_cookie(:test_jwt, token, domain: '.example.com')
    end

    def sign_in
      mock_sso_auth

      visit root_path

      unless Satellite.configuration.enable_auto_login?
        click_link "Sign in"
      end
    end
  end
end

RSpec.configure do |config|
  config.include OmniAuthHelpers::Mock
  config.include OmniAuthHelpers::SessionHelpers, type: :feature
end

OmniAuth.config.test_mode = true
