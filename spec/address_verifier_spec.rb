require "spec_helper"

RSpec.describe Heimdall::AddressVerifier do

  describe "#call" do
    context "when the address is verifiable" do

      it "does not assign an error" do
        address = build(:fake_address, street1: "939 Industrial Ave",
                                       city: "Palo Alto",
                                       state: "CA",
                                       zip: "94303")
        verification_service = Heimdall::AddressVerifier.new(address)
        allow(address).to receive(:errors)

        verification_service.call

        expect(address).not_to have_received(:errors)
      end

      it "standardizes the address" do
        address = build(:fake_address)
        verification_service = Heimdall::AddressVerifier.new(address)
        allow(address).to receive(:assign_attributes)

        verification_service.call

        expect(address).to have_received(:assign_attributes)
      end

      it "marks the address as verified" do
        address = build(:fake_address, verified: false)
        verification_service = Heimdall::AddressVerifier.new(address)

        verification_service.call

        expect(address).to be_verified
      end
    end

    context "when the address is not verifiable" do
      it "assigns a base error" do
        address = FakeAddress.new
        allow(address).to receive(:verifiable?).and_return(false)
        verification_service = Heimdall::AddressVerifier.new(address)
        errors = { base: [] }
        allow(address).to receive(:errors).and_return(errors)

        verification_service.call

        expect(address).to have_received(:errors)
      end
    end

    context "when the address is missing information" do
      it "assigns a base error" do
        FakeLob.return_partial_match
        address = FakeAddress.new
        verification_service = Heimdall::AddressVerifier.new(address)
        errors = { base: [] }
        allow(address).to receive(:errors).and_return(errors)

        verification_service.call

        expect(address).to have_received(:errors)
      end
    end

    context "when the address is not found" do
      it "assigns a base error" do
        FakeLob.raise_address_not_found
        address = FakeAddress.new
        verification_service = Heimdall::AddressVerifier.new(address)
        errors = { base: [] }
        allow(address).to receive(:errors).and_return(errors)

        verification_service.call

        expect(address).to have_received(:errors)
      end
    end

  end

end
