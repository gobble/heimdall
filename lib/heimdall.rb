require "active_model"
require "active_support"
require "active_support/core_ext"

require "heimdall/address"
require "heimdall/address_validator"
require "heimdall/address_verifier"
require "heimdall/errors"
require "heimdall/utils/verification_client"
require "heimdall/version"

require "lob"

module Heimdall
  class << self
    def log
      @logger ||= initialize_logger
    end

    def verification_url
      "https://#{ENV['LOB_API_KEY']}:@api.lob.com/v1/us_verifications"
    end

    private

    def initialize_logger
      logger = Logger.new(STDERR)
      logger.level = Logger::DEBUG
      logger.datetime_format = "%Y-%m-%d %H:%M:%S"
      logger
    end
  end
end
