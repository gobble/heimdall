require "lob"

class FakeLob

  def initialize(api_key: nil, api_version: nil); end

  def addresses
    self
  end

  def verify(options)
    initialize_class_variables
    return partial_match_response if @@partial_match
    return address_not_found_response if @@address_not_found
    {
      "address" => {
        "address_line1" => options[:address_line1],
        "address_line2" => options[:address_line2],
        "address_city" => options[:address_city],
        "address_state" => options[:address_state],
        "address_zip" => options[:address_zip],
      },
    }
  end

  def self.return_partial_match
    @@partial_match = true
  end

  def self.raise_address_not_found
    @@address_not_found = true
  end

  def self.clear
    @@partial_match = false
    @@address_not_found = false
  end

  protected

  def partial_match_response
    { "message" => "address is missing information" }
  end

  def address_not_found_response
    fail Lob::InvalidRequestError.new(
      "error": {
        "message" => "address not found",
        "status_code" => 404,
      }
    )
  end

  def initialize_class_variables
    @@partial_match ||= false
    @@address_not_found ||= false
  end

end
