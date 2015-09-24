require "hashie"

module Satellite
  module User
    extend ActiveSupport::Concern

    module ClassMethods
      def create_with_omniauth(auth)
        auth.extend Hashie::Extensions::DeepFetch
        create! do |user|
          user.provider = auth['provider']
          user.uid      = auth['uid']
          user.name  = [
            auth.deep_fetch('info', 'first_name') { '' } ,
            auth.deep_fetch('info', 'last_name') { '' }
          ].join(' ')
          user.email = auth.deep_fetch('info', 'email') { "" }
        end
      end

      def find_with_omniauth(auth)
        find_by(provider: auth['provider'], uid: auth['uid'].to_s)
      end

      def find_or_create_with_omniauth(auth)
        find_with_omniauth(auth) || create_with_omniauth(auth)
      end
    end

    def registered?
      persisted?
    end

    def provider_key
      [provider, uid]
    end

    def provider_key?(key)
      provider_key.map(&:to_s) == Array[*key].map(&:to_s)
    end
  end
end
