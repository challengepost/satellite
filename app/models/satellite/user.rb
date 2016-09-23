require "hashie"

module Satellite
  module User
    extend ActiveSupport::Concern

    module ClassMethods
      def create_with_omniauth(auth)
        auth.extend Hashie::Extensions::DeepFetch
        create! do |user|
          user.provider = auth["provider"]
          user.uid      = auth["uid"]

          user_info_attributes.each do |attribute|
            setter = "#{attribute}="
            if user.respond_to? setter
              user.send(setter, auth.deep_fetch("info", attribute.to_s) { "" })
            end
          end
        end
      end

      def user_info_attributes
        # https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema
        [:nickname, :name, :first_name, :last_name, :email, :image, :description, :location, :phone]
      end

      def find_with_omniauth(auth)
        find_by(provider: auth["provider"], uid: auth["uid"].to_s)
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
