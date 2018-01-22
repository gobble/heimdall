module Heimdall
  class AddressVerifier

    delegate :line1, :city, :state, :zip_code, to: :address

    def initialize(address)
      @address = address
    end

    def call
      verify
    rescue AddressError => e
      add_error(e)
      false
    end

    protected

    attr_reader :last_response, :address

    def verify
      @last_response = verify_address
      if last_response.present?
        handle_last_response
        standardize_address
      end
    end

    def standardize_address
      return unless successful?
      update_address(last_response)
    end

    def update_address(new_values)
      address.assign_attributes(
        street1: new_values["primary_line"],
        street2: new_values["secondary_line"],
        city: new_values["components"]["city"],
        state: new_values["components"]["state"],
        zip_code: new_values["components"]["zip_code"],
        commercial: commercial_address?,
        verified: true
      )
    end

    def successful?
      @success
    end

    def handle_last_response
      if missing_information?
        fail Heimdall::MissingInformationError
      elsif no_match_found?
        fail Heimdall::UnverifiableAddressError
      else
        @success = true
      end
    end

    def commercial_address?
      last_response["components"]["address_type"] == "commercial"
    end

    def no_match_found?
      last_response["deliverability"] == "no_match"
    end

    def missing_information?
      last_response["deliverability"] == "deliverable_extra_secondary" ||
        last_response["deliverability"] == "deliverable_missing_secondary"
    end

    def verify_address
      response = verification_client.verify(address)
      unless response
        fail Heimdall::UnverifiableAddressError
      end
      response
    end

    def verification_client
      @client ||= Utils::VerificationClient.new
    end

    def add_error(error)
      address.errors[error.attribute] << error.message
    end

  end
end
