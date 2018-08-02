module Heimdall
  class AddressStandardizer
    delegate :primary_field, :deliverability, to: :lob_response

    def initialize(address)
      @address = address
    end

    def standardize
      if lob_response.present?
        standardize_address
      else
        fail UnverifiableAddressError
      end
    end

    private

    attr_reader :address, :lob_response

    def lob_response
      @lob_response ||= verify_address
    end

    def verification_client
      @client ||= Utils::VerificationClient.new
    end

    def verify_address
      verification_client.verify(address)
    end

    def standardize_address
      address.assign_attributes(
        street1: lob_response.primary_line,
        street2: lob_response.secondary_line,
        city: lob_response.city,
        state: lob_response.state,
        zip_code: lob_response.zip_code,
        commercial: lob_response.commercial?
      )
    end

  end
end
