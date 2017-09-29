module Heimdall
  class AddressVerifier

    def initialize(address)
      @address = address
    end

    def call
      if address.verifiable?
        verify
      else
        add_error(errors.incomplete_address_error)
      end
    end

    protected

    attr_reader :last_response, :address

    def verify
      @last_response = verify_address
      handle_last_response
      standardize_address
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
        zip: new_values["address_zip"],
        verified: true
      )
    end

    def successful?
      @success
    end

    def handle_last_response
      if last_response.has_key?("message")
        add_error(errors.missing_information_error)
      else
        @success = true
      end
    end

    def verify_address
      response = verification_client.verify(address)
      unless response
        @success = false
        add_error(errors.unverifiable_address_error)
      end
      response
    end

    def add_error(message)
      address.errors[:base] << message
    end

    def verification_client
      @client ||= Utils::VerificationClient.new
    end

    def errors
      @_errors ||= Heimdall::Utils::Errors.new
    end

  end
end
