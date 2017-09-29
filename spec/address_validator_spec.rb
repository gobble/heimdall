require "spec_helper"

RSpec.describe Heimdall::AddressValidator do

  describe "#validate" do
    it "calls the address verifier" do
      validator = Heimdall::AddressValidator.new(unused_options)
      address = stub_address(verifiable: true)
      verification_service = Heimdall::AddressVerifier.new(address)
      allow(verification_service).to receive(:call)
      allow(Heimdall::AddressVerifier).to receive(:new).
        and_return(verification_service)

      validator.validate(address)

      expect(verification_service).to have_received(:call)
    end
  end

  let(:unused_options) { {} }

  def stub_address(verifiable:)
    address = FakeAddress.new
    allow(address).to receive(:verifiable?).and_return(verifiable)
    address
  end

end
