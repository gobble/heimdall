module Heimdall
  module Utils
    class Errors
      def missing_information_error
        <<~HEREDOC
          The address you entered was found but more information is needed (such
          as an apartment, suite, or box number) to match to a specific address.
        HEREDOC
      end

      def unverifiable_address_error
        <<~HEREDOC
          The address cannot be found. Please double-check the information or
          contact us if you have any questions.
        HEREDOC
      end

      def incomplete_address_error
        "The address is incomplete."
      end
    end
  end
end
