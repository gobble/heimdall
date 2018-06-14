module Heimdall
  class AddressVerifier

    ERROR_MAPPINGS = {
      deliverable_incorrect_unit: DeliverableIncorrectUnitError,
      deliverable_missing_unit: DeliverableMissingUnitError,
      undeliverable: UndeliverableAddressError
    }

    delegate :line1, :city, :state, :zip_code, to: :address

    def initialize(address)
      @address = address
    end

    def call
      verify
    rescue UndeliverableAddressError, UnverifiableAddressError => e
      add_error(e)
      log_error(e)
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
      if has_error?
        fail error_class
      else
        @success = true
      end
    end

    def has_error?
      ERROR_MAPPINGS[deliverability_status].present?
    end

    def error_class
      ERROR_MAPPINGS[deliverability_status]
    end

    def deliverability_status
      last_response["deliverability"].to_sym
    end

    def commercial_address?
      last_response["components"]["address_type"] == "commercial"
    end

    def verify_address
      response = verification_client.verify(address)
      unless response
        fail UnverifiableAddressError
      end
      response
    end

    def verification_client
      @client ||= Utils::VerificationClient.new
    end

    def add_error(error)
      address.errors[error.attribute] << error.message
    end

    def log_error(e)
      Heimdall.log.error "Error occurred while verifying #{address}, " \
                         "message: #{e.message}"
    end

  end
end
