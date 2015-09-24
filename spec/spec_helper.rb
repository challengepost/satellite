# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../example/config/environment.rb",  __FILE__)

require "rspec/rails"
require "capybara/rspec"
require "factory_girl_rails"
require "show_me_the_cookies"
require "database_cleaner"

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), "../")

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
end

Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

ActiveRecord::Migration.maintain_test_schema!
