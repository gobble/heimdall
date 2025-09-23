module Heimdall
  module Utils
    class IntelligentFoodsAdapter
      attr_reader :client

      def verify(address)
        authenticate_client!
        response = verify_address(address)
        build_intelligent_foods_response(response)
      end

      def self.build
        client = IntetelligentFoods.client
        new(client: client)
      end

      protected

      def authenticate_client!
        return if IntelligentFoods.client.authenticated?
        IntelligentFoods.client.authenticate!
      end

      def verify_address(address)
        address = IntelligentFoods::Address.new(address1: address.line1,
                                                address2: address.line2,
                                                city: "San Francisco",
                                                state: "CA",
                                                zip: "12345")
        address.verify!
      end

      def build_response(response)

      end
    end
  end
end
