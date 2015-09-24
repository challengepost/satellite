require "uri"

module Satellite
  class DatabaseURI < URI::Generic
    def self.parse(url)
      config = URI.parse(url)
      new(*%w[scheme userinfo host port registry path opaque query fragment].map { |a| config.send(a)})
    end

    def adapter
      adjusted_scheme
    end

    def username
      user
    end

    def database
      path.sub(%r{^/},"")
    end

    def params
      split_query_options
    end

    def to_hash
      {
        adapter:  adapter,
        username: username,
        password: password,
        port:     port,
        database: database,
        host:     host
      }.merge(params).reject { |k,v| v.nil? }
    end

    private

    def adjusted_scheme
      return "postgresql" if scheme == "postgres"
      scheme
    end

    def split_query_options
      return {} unless query
      Hash[query.split("&").map{ |pair| pair.split("=") }].symbolize_keys
    end
  end
end
