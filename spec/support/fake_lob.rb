require "lob"

class FakeLob

  def initialize(api_key: nil, api_version: nil); end

  def us_verifications
    self
  end

  def verify(options)
    initialize_class_variables
    return partial_match_response if @@partial_match
    {
      "primary_line" => options[:primary_line],
      "secondary_line" => options[:secondary_line],
      "deliverability" => "deliverable",
      "components" => {
        "city" => options[:city],
        "state" => options[:state],
        "zip_code" => options[:zip_code],
        "address_type" => @@address_type
      }
    }
  end

  def self.return_complete_match(address_type:)
    @@address_type = address_type
  end

  def self.return_partial_match(deliverability_status:)
    @@partial_match = true
    @@deliverability_status = deliverability_status
  end

  def self.return_address_not_found
    return_partial_match(deliverability_status: "undeliverable")
  end

  def self.clear
    @@partial_match = false
    @@deliverability_status = ""
  end

  protected

  def partial_match_response
    { "deliverability" => @@deliverability_status }
  end

  def initialize_class_variables
    @@partial_match ||= false
    @@address_type ||= "residential"
  end

end
