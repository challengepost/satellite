# spec/spec_helper.rb
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do |example|
    case example.metadata[:satellite]
    when :manual_login
      allow(Satellite.configuration).to receive(:enable_auto_login?) { false }
    when :auto_login
      allow(Satellite.configuration).to receive(:enable_auto_login?) { true }
    else
      # default to environment settings
    end
  end
end
