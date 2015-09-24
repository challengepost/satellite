# Satellite

[![Build Status](https://travis-ci.org/challengepost/satellite.svg)](https://travis-ci.org/challengepost/satellite)

Satellite is a Rails engine for client authentication against an OAuth provider
via [OmniAuth](https://github.com/intridea/omniauth). The use case for this
engine is to build a client application on a site where you're already
authenticated to share authorization privileges; i.e. single-sign-on via OAuth.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "satellite"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install satellite

## Usage

Satellite assumes that you're building a Rails client application that will authorize
against a single OAuth provider and a single OmniAuth strategy. This strategy
may be either written internally or brought in as a gem.
`gem "omniauth-devpost"`

To setup Satellte, run the generator to create the initializer file and mount the Satellite routes:

`rails g satellite:install`

A sample Satellite configuration is shown below, including options for the OmniAuth
strategy it is meant to wrap. OAuth provider credentials, such as a key and secret for a registered application, may be necessary to acquire before set up.

```ruby
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
```

### Controller methods

Satellite provides a number of controller extensions similar to Devise, all
assuming the resource name "user".

To ensure a user is authorized in a `before_action`:

```ruby
before_action :authorize_user!
```

Accessing the current user:

```ruby
current_user     # returns an authenticated user or an "anonymous" user (null object)
user_signed_in?  # the user is authenticated, not "anonymous"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/satellite/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
