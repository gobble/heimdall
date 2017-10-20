require "active_model"
require "active_support"
require "active_support/core_ext"
require "heimdall/version"
require "heimdall/address"
require "heimdall/address_verifier"
require "heimdall/utils/errors"
require "heimdall/utils/verification_client"
require "heimdall/address_validator"

module Heimdall
  class << self
    def log
      @logger ||= initialize_logger
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
