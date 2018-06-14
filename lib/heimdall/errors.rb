module Heimdall
  class AddressError < StandardError; end

  class DeliverableIncorrectUnitError < AddressError
    def message
      <<~HEREDOC
        The address you entered was found but the secondary line does
        not exist. Please double-check the secondary line information.
      HEREDOC
    end
  end

  class DeliverableMissingUnitError < AddressError
    def message
      <<~HEREDOC
        The address you entered was found but more information is needed (such
        as an apartment, suite, or box number) to match to a specific address.
      HEREDOC
    end
  end

  class UndeliverableAddressError < AddressError
    def message
      <<~HEREDOC
        The address cannot be found. Please double-check the information or
        contact us if you have any questions.
      HEREDOC
    end

    def attribute
      :street1
    end
  end

  class UnverifiableAddressError < AddressError
    def message
      "The address cannot be verified at the moment. Please try again later"
    end

    def attribute
      :street1
    end
  end

end
