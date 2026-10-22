module Heimdall
  module Utils

    class VerificationResponse

      DELIVERABLE = :deliverable
      INCORRECT_UNIT = :incorrect_unit
      MISSING_UNIT = :missing_unit
      UNNECESSARY_UNIT = :unnecessary_unit
      UNDELIVERABLE = :undeliverable

      DELIVERABILITY_STATUSES = [
        DELIVERABLE, INCORRECT_UNIT, MISSING_UNIT, UNNECESSARY_UNIT,
        UNDELIVERABLE
      ].freeze

      attr_reader :street1, :street2, :primary_field, :city, :state,
                  :zip_code, :deliverability, :commercial

      def initialize(deliverability:, street1: nil, street2: nil,
                     primary_field: nil, city: nil, state: nil,
                     zip_code: nil, commercial: false)
        @deliverability = deliverability
        @street1 = street1
        @street2 = street2
        @primary_field = primary_field
        @city = city
        @state = state
        @zip_code = zip_code
        @commercial = commercial
      end

      def commercial?
        commercial
      end

      def deliverable?
        deliverability == DELIVERABLE
      end

    end
  end
end
