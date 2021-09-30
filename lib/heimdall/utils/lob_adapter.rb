module Heimdall
  module Utils
    class LobAdapter
      attr_reader :client

      def initialize(client: nil)
        @client = client
      end

      def verify(address)
        response = verify_address(address)
        build_lob_response(response)
      end

      def self.build
        client = Lob::Client.new(
          api_key: ENV.fetch("LOB_API_KEY", ""),
          api_version: ENV.fetch("LOB_API_VERSION", "")
        )
        new(client: client)
      end

      protected

      def verify_address(address)
        client.us_verifications.verify(
          primary_line: address.line1,
          secondary_line: address.line2,
          city: address.city,
          state: address.state,
          zip_code: address.zip_code
        )
      end

      def build_lob_response(response)
        VerificationResponse.build(response)
      end
    end
  end
end
