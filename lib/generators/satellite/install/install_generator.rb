module Satellite
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer
        template "satellite.rb", "config/initializers/satellite.rb"
      end

      def setup_routes
        route "mount Satellite::Engine => \"/satellite\""
      end
    end
  end
end
