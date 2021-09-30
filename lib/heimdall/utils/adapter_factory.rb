module Heimdall
  module Utils
    class AdapterFactory
      LOB = "lob".freeze

      def initialize(provider:)
        @provider = provider
      end

      def create
        verification_client
      end

      def self.build
        new(provider: LOB).create
      end

      protected

      attr_reader :provider

      def verification_client
        if provider == LOB
          Heimdall::Utils::LobAdapter.build
        end
      end
    end
  end
end
