module Heimdall
  class AddressError < StandardError; end

  class MissingInformationError < AddressError
    def message
      <<~HEREDOC
        The address you entered was found but more information is needed (such
        as an apartment, suite, or box number) to match to a specific address.
      HEREDOC
    end

    # TODO standardize street1 and street2 to line1 and line2 accross all apps
    def attribute
      :street2
    end
  end

  class UnverifiableAddressError < AddressError
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

end
