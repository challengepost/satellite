# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'satellite/version'

Gem::Specification.new do |spec|
  spec.name          = "satellite"
  spec.version       = Satellite::VERSION
  spec.authors       = ["Ross Kaffenberger"]
  spec.email         = ["rosskaff@gmail.com"]
  spec.summary       = %q{Rails engine for single-sign-on client applications}
  spec.description   = %q{Rails engine for client applications to provide single-sign-on authorization via OmniAuth and Warden}
  spec.homepage      = "https://github.com/challengepost/satellite"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 3.2"
  spec.add_dependency "warden"
  spec.add_dependency "hashie"

  spec.add_development_dependency "rack", "~> 1.6.4"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "factory_girl_rails"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "ffaker"
  spec.add_development_dependency "launchy"
  spec.add_development_dependency "show_me_the_cookies"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "high_voltage"
end
