require 'satellite'

module Satellite
  class Engine < ::Rails::Engine

    initializer "satellite.configure_controllers" do
      ActiveSupport.on_load(:action_controller) do
        include Satellite::ControllerExtensions
      end
    end

    initializer "satellite precompile" do |app|
      app.config.assets.precompile += %w[satellite.css cowboy.png]
    end

    initializer "satellite.finalize_configuration" do |app|
      Satellite.finalize_configuration!(app)
    end

  end
end
