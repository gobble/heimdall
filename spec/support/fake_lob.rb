require "lob"

class FakeLob

  def initialize(api_key: nil, api_version: nil); end

  def us_verifications
    self
  end

  def verify(options)
    initialize_class_variables
    return partial_match_response if @@partial_match
    return address_not_found_response if @@address_not_found
    {
      "primary_line" => options[:primary_line],
      "secondary_line" => options[:secondary_line],
      "deliverability" => "deliverable",
      "components" => {
        "city" => options[:city],
        "state" => options[:state],
        "zip_code" => options[:zip_code]
      }
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
    { "deliverability" => "deliverable_extra_secondary" }
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
