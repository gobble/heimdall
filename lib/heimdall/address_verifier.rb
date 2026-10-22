module Heimdall
  class AddressVerifier

    STATUSES = Utils::VerificationResponse

    ERROR_MAPPINGS = {
      STATUSES::INCORRECT_UNIT => DeliverableIncorrectUnitError,
      STATUSES::MISSING_UNIT => DeliverableMissingUnitError,
      STATUSES::UNNECESSARY_UNIT => DeliverableUnnecessaryUnitError,
      STATUSES::UNDELIVERABLE => UndeliverableAddressError
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
      if address_standardizer.deliverable?
        address.verified = true
      else
        handle_undeliverable_address!
      end
    end

    def handle_undeliverable_address!
      if error_class.present?
        raise error_class
      else
        log_unknown_deliverability_status
        raise UndeliverableAddressError
      end
    end

    def error_class
      @error_class ||= ERROR_MAPPINGS.fetch(deliverability_status, nil)
    end

    def deliverability_status
      address_standardizer.deliverability_status
    end

    def add_error(error)
      address.errors.add(error.attribute, message: error.message)
    end

    def log_unknown_deliverability_status
      Heimdall.log.warn "Unknown deliverability status " \
                        "#{deliverability_status.inspect} while verifying " \
                        "#{address}, treating it as undeliverable"
    end

    def log_error(e)
      Heimdall.log.error "Error occurred while verifying #{address}, " \
                         "message: #{e.message}"
    end

  end
end
