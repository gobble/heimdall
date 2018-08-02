class FakeAddress
  attr_accessor :address, :street1, :street2, :city, :zip, :state,
                :commercial, :verified

  alias_attribute :line1, :street1
  alias_attribute :line2, :street2
  alias_attribute :zip_code, :zip

  def initialize(params = {})
    params.each { |attr, value| public_send("#{attr}=", value) }
  end

  def assign_attributes(attributes)
    attributes.each { |attr, value| public_send("#{attr}=", value) }
  end

  def verified?
    verified
  end

  def self.not_verifiable_address
    new(line1: "", city: "")
  end

  def standardizer
    @standardizer ||= Heimdall::AddressStandardizer.new(self)
  end

end
