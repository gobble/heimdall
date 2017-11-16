module Heimdall
  module Utils
    class VerificationClient

      def verify(address)
        verify_address(address)
      rescue Lob::InvalidRequestError => e
        handle_error(e)
      end

      protected

      def verify_address(address)
        lob_client.us_verifications.verify(
          primary_line: address.line1,
          secondary_line: address.line2,
          city: address.city,
          state: address.state,
          zip_code: address.zip_code
        )
      end

      def lob_client
        @client ||= Lob::Client.new(
          api_key: ENV.fetch("LOB_API_KEY", ""),
          api_version: ENV.fetch("LOB_API_VERSION", "")
        )
      end

      def handle_error(e)
        Heimdall.log.info(e.message)
        nil
      end

    end
  end
end
