require "spec_helper"

RSpec.describe Heimdall::AddressVerifier do

  describe "#call" do
    it "marks the address as verified" do
      address = build(:fake_address, verified: false)
      stub_standardizer(address, "deliverbale")
      verification_service = Heimdall::AddressVerifier.new(address)

      verification_service.call

      expect(address).to be_verified
    end

    context "when the address secondary unit is incorrect" do
      it "raises a DeliverableIncorrectUnitError" do
        address = build(:fake_address)
        stub_standardizer(address, "deliverable_incorrect_unit")
        verification_service = Heimdall::AddressVerifier.new(address)

        expect {
          verification_service.call
        }.to raise_error(Heimdall::DeliverableIncorrectUnitError)
      end
    end

    context "when the address secondary unit is missing" do
      it "raises a DeliverableMissingUnitError" do
        address = build(:fake_address)
        stub_standardizer(address, "deliverable_missing_unit")
        verification_service = Heimdall::AddressVerifier.new(address)

        expect {
          verification_service.call
        }.to raise_error(Heimdall::DeliverableMissingUnitError)
      end
    end

    context "when the address secondary unit is unnecessary" do
      it "raises a DeliverableUnnecessaryUnitError" do
        address = build(:fake_address)
        stub_standardizer(address, "deliverable_unnecessary_unit")
        verification_service = Heimdall::AddressVerifier.new(address)

        expect {
          verification_service.call
        }.to raise_error(Heimdall::DeliverableUnnecessaryUnitError)
      end
    end

    context "when the address is not found" do
      it "populates the street1 attribute in the errors hash" do
        address = build(:fake_address)
        stub_standardizer(address, "undeliverable")
        verification_service = Heimdall::AddressVerifier.new(address)

        verification_service.call

        expect(address.errors.messages[:street1]).
          to include(/The address cannot be found./)
      end
    end

    def stub_standardizer(address, deliverability)
      standardizer = Heimdall::AddressStandardizer.new(address)
      allow(standardizer).to receive(:deliverability).and_return(deliverability)
      allow(Heimdall::AddressStandardizer).to receive(:new).
        and_return(standardizer)
      standardizer
    end

  end
end
