module Heimdall
  module Utils
    class VerificationClient

      def verify(address)
        verify_address(address)
      rescue Lob::InvalidRequestError => e
        Rails.logger.error(e.message)
      end

      protected

      def verify_address(address)
        lob_client.addresses.verify(
          address_line1: address.line1,
          address_line2: address.line2,
          address_city: address.city,
          address_state: address.state,
          address_zip: address.zip_code
        )
      end

      def lob_client
        @client ||= Lob::Client.new(
          api_key: ENV["LOB_API_KEY"],
          api_version: ENV["LOB_API_VERSION"]
        )
      end

    end
  end
end
