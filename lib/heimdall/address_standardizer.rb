module Heimdall
  class AddressStandardizer
    delegate :primary_field, :deliverability, to: :verification_response

    def initialize(address)
      @address = address
    end

    def standardize
      standardize_address
    rescue StandardError => e
      handle_error(e)
    end

    private

    attr_reader :address

    def verification_response
      @verification_response ||= verify_address
    end

    def verification_client
      @verification_client ||= Utils::AdapterFactory.build
    end

    def verify_address
      verification_client.verify(address)
    end

    def standardize_address
      address.assign_attributes(
        street1: verification_response.primary_line,
        street2: verification_response.secondary_line,
        city: verification_response.city,
        state: verification_response.state,
        zip_code: verification_response.zip_code,
        commercial: verification_response.commercial?
      )
    end

    def handle_error(error)
      Heimdall.log.info(error.message)
      raise Heimdall::UnverifiableAddressError
    end
  end
end
