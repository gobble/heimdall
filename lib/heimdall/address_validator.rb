module Heimdall
  class AddressValidator < ActiveModel::Validator

    def validate(record)
      verification_service = AddressVerifier.new(record)
      verification_service.call
    end

  end  
end
