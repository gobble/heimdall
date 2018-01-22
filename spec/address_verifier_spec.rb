require "spec_helper"

RSpec.describe Heimdall::AddressVerifier do
  before { FakeLob.clear }

  describe "#call" do
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

    context "for a commercial address" do
      it "sets the commercial field to true" do
        FakeLob.return_complete_match(
          address_type: "commercial"
        )
        address = build(:fake_address)
        verification_service = Heimdall::AddressVerifier.new(address)

        verification_service.call

        expect(address.commercial).to be_truthy
      end
    end

    context "for a non-commercial address" do
      it "sets the commercial field to false" do
        FakeLob.return_complete_match(
          address_type: "residential"
        )
        address = build(:fake_address)
        verification_service = Heimdall::AddressVerifier.new(address)

        verification_service.call

        expect(address.commercial).to be_falsey
      end
    end

    context "when the address is missing information" do
      context "and deliverability status is deliverable_missing_secondary" do
        it "populates the street2 attribute in the errors hash" do
          FakeLob.return_partial_match(
            deliverability_status: "deliverable_missing_secondary"
          )
          address = stub_address
          verification_service = Heimdall::AddressVerifier.new(address)

          verification_service.call

          expect(address.errors[:street2]).
            to include(/The address you entered was found/)
        end
      end

      context "and deliverability status is deliverable_extra_secondary" do
        it "populates the street2 attribute in the errors hash" do
          FakeLob.return_partial_match(
            deliverability_status: "deliverable_extra_secondary"
          )
          address = stub_address
          verification_service = Heimdall::AddressVerifier.new(address)

          verification_service.call

          expect(address.errors[:street2]).
            to include(/The address you entered was found/)
        end
      end
    end

    context "when the address is not found" do
      it "populates the street1 attribute in the errors hash" do
        FakeLob.raise_address_not_found
        address = stub_address
        verification_service = Heimdall::AddressVerifier.new(address)

        verification_service.call

        expect(address.errors[:street1]).
          to include(/The address cannot be found./)
      end
    end

    def stub_address
      address = build(:fake_address)
      allow(address).to receive(:errors).and_return(street1: [], street2: [])
      address
    end

  end

end
