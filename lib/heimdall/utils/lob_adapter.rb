module Heimdall
  module Utils
    class LobAdapter
      DEFAULT_DELIVERABILITY = VerificationResponse::UNDELIVERABLE

      DELIVERABILITY_MAPPINGS = {
        deliverable: VerificationResponse::DELIVERABLE,
        deliverable_incorrect_unit: VerificationResponse::INCORRECT_UNIT,
        deliverable_missing_unit: VerificationResponse::MISSING_UNIT,
        deliverable_unnecessary_unit: VerificationResponse::UNNECESSARY_UNIT,
        undeliverable: DEFAULT_DELIVERABILITY,
      }.freeze

      COMMERCIAL_ADDRESS_TYPE = "commercial".freeze

      attr_reader :client

      def initialize(client: nil)
        @client = client
      end

      def verify(address)
        response = verify_address(address)
        build_verification_response(response.deep_symbolize_keys)
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

      def build_verification_response(response)
        components = response.fetch(:components, {})

        VerificationResponse.new(
          street1: response[:primary_line],
          street2: response[:secondary_line],
          primary_field: build_primary_field(components),
          city: components[:city],
          state: components[:state],
          zip_code: components[:zip_code],
          deliverability: build_deliverability(response[:deliverability]),
          commercial: components[:address_type] == COMMERCIAL_ADDRESS_TYPE
        )
      end

      def build_deliverability(lob_deliverability)
        DELIVERABILITY_MAPPINGS.fetch(
          lob_deliverability.to_s.to_sym,
          DEFAULT_DELIVERABILITY
        )
      end

      def build_primary_field(components)
        primary_line_components.
          map { |component| components[component].to_s }.
          reject(&:empty?).
          join(" ")
      end

      def primary_line_components
        %i(
          primary_number street_predirection street_name street_suffix
          street_postdirection
        )
      end
    end
  end
end
