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
      update_address(last_response["address"])
    end

    def update_address(new_values)
      address.assign_attributes(
        street1: new_values["address_line1"],
        street2: new_values["address_line2"],
        city: new_values["address_city"],
        state: new_values["address_state"],
        zip_code: new_values["address_zip"],
        verified: true
      )
    end

    def successful?
      @success
    end

    def handle_last_response
      if last_response.has_key?("message")
        fail Heimdall::MissingInformationError
      else
        @success = true
      end
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
