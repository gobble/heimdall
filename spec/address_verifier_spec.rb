require "spec_helper"

RSpec.describe Heimdall::AddressVerifier do

  describe "#call" do
    it "marks the address as verified" do
      address = build(:fake_address, verified: false)
      stub_standardizer(address, :deliverable)
      verification_service = Heimdall::AddressVerifier.new(address)

      verification_service.call

      expect(address).to be_verified
    end

    context "when the address secondary unit is incorrect" do
      it "raises a DeliverableIncorrectUnitError" do
        address = build(:fake_address)
        stub_standardizer(address, :incorrect_unit)
        verification_service = Heimdall::AddressVerifier.new(address)

        expect {
          verification_service.call
        }.to raise_error(Heimdall::DeliverableIncorrectUnitError)
      end
    end

    context "when the address secondary unit is missing" do
      it "raises a DeliverableMissingUnitError" do
        address = build(:fake_address)
        stub_standardizer(address, :missing_unit)
        verification_service = Heimdall::AddressVerifier.new(address)

        expect {
          verification_service.call
        }.to raise_error(Heimdall::DeliverableMissingUnitError)
      end
    end

    context "when the address secondary unit is unnecessary" do
      it "raises a DeliverableUnnecessaryUnitError" do
        address = build(:fake_address)
        stub_standardizer(address, :unnecessary_unit)
        verification_service = Heimdall::AddressVerifier.new(address)

        expect {
          verification_service.call
        }.to raise_error(Heimdall::DeliverableUnnecessaryUnitError)
      end
    end

    context "when the address is not found" do
      it "populates the street1 attribute in the errors hash" do
        address = build(:fake_address)
        stub_standardizer(address, :undeliverable)
        verification_service = Heimdall::AddressVerifier.new(address)

        verification_service.call

        expect(address.errors.messages[:street1]).
          to include(/The address cannot be found./)
      end
    end

    context "when the deliverability status is unknown" do
      it "populates the street1 attribute in the errors hash" do
        address = build(:fake_address)
        stub_standardizer(address, :no_match)
        verification_service = Heimdall::AddressVerifier.new(address)

        verification_service.call

        expect(address.errors.messages[:street1]).
          to include(/The address cannot be found./)
      end
    end

    context "when the deliverability status is unknown" do
      it "logs the unknown status" do
        address = build(:fake_address)
        stub_standardizer(address, :no_match)
        allow(Heimdall.log).to receive(:warn)
        verification_service = Heimdall::AddressVerifier.new(address)

        verification_service.call

        expect(Heimdall.log).to have_received(:warn).
          with(/Unknown deliverability status :no_match/)
      end
    end

    context "when the deliverability status is known" do
      it "does not log an unknown status" do
        address = build(:fake_address)
        stub_standardizer(address, :undeliverable)
        allow(Heimdall.log).to receive(:warn)
        verification_service = Heimdall::AddressVerifier.new(address)

        verification_service.call

        expect(Heimdall.log).to_not have_received(:warn)
      end
    end

    context "when the address cannot be verified" do
      it "populates the street1 attribute in the errors hash" do
        address = build(:fake_address)
        stub_verification_error
        verification_service = Heimdall::AddressVerifier.new(address)

        verification_service.call

        expect(address.errors.messages[:street1]).
          to include(/The address cannot be verified/)
      end
    end

    def stub_verification_error
      client = Heimdall::Utils::AdapterFactory.build
      allow(client).to receive(:verify).
        and_raise(RestClient::SSLCertificateNotVerified)
      allow(Heimdall::Utils::AdapterFactory).
        to receive(:build).and_return(client)
    end

    def stub_standardizer(address, deliverability)
      standardizer = Heimdall::AddressStandardizer.new(address)
      allow(standardizer).to receive(:deliverability).and_return(deliverability)
      allow(standardizer).to receive(:deliverable?).
        and_return(deliverability == :deliverable)
      allow(Heimdall::AddressStandardizer).to receive(:new).
        and_return(standardizer)
      standardizer
    end

  end
end
