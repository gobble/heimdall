module Heimdall
  class AddressVerifier

    ERROR_MAPPINGS = {
      deliverable_incorrect_unit: DeliverableIncorrectUnitError,
      deliverable_missing_unit: DeliverableMissingUnitError,
      undeliverable: UndeliverableAddressError,
    }.freeze

    delegate :line1, :city, :state, :zip_code, to: :address

    def initialize(address)
      @address = address
    end

    def call
      verify_address
    rescue UndeliverableAddressError, UnverifiableAddressError => e
      add_error(e)
      log_error(e)
    end

    protected

    attr_reader :last_response, :address

    def address_standardizer
      address.standardizer
    end

    def verify_address
      if has_error?
        fail error_class
      else
        address.verified = true
      end
    end

    def has_error?
      ERROR_MAPPINGS[deliverability_status].present?
    end

    def error_class
      ERROR_MAPPINGS[deliverability_status]
    end

    def deliverability_status
      address_standardizer.deliverability.to_sym
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
