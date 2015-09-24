module Satellite
  Error = Class.new(StandardError)

  AccessDenied = Class.new(Error)
  ConfigurationError = Class.new(Error)
end
