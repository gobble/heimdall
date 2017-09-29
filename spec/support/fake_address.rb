class FakeAddress

  attr_accessor :address, :street1, :street2, :city, :zip, :state, :verified

  alias :line1 :street1
  alias :line2 :street2
  alias :zip_code :zip

  def initialize(params = {})
    params.each { |attr, value| public_send("#{attr}=", value) }
  end

  def verifiable?
    street1.present? && city.present? && state.present? && zip.present?
  end

  def errors
    { base: [] }
  end

  def assign_attributes(attributes)
    attributes.each { |attr, value| public_send("#{attr}=", value) }
  end

  def verified?
    verified
  end

end
