require "spec_helper"

RSpec.describe Heimdall::AddressStandardizer do

  before { FakeLob.clear }

  describe "#standardize" do
    it "standardizes the address" do
      address = build(:fake_address)
      standardizer = Heimdall::AddressStandardizer.new(address)
      allow(address).to receive(:assign_attributes)

      standardizer.standardize

      expect(address).to have_received(:assign_attributes)
    end

    context "when there is a verification request error" do
      it "fails with UnverifiableAddressError" do
        client = stub_verification_client
        allow(client).to receive(:verify).
          and_raise(RestClient::SSLCertificateNotVerified)
        address = build(:fake_address)
        standardizer = Heimdall::AddressStandardizer.new(address)

        expect {
          standardizer.standardize
        }.to raise_error(Heimdall::UnverifiableAddressError)
      end
    end

    context "for a commercial address" do
      it "sets the commercial field to true" do
        FakeLob.return_complete_match(
          address_type: "commercial"
        )
        address = build(:fake_address)
        standardizer = Heimdall::AddressStandardizer.new(address)

        standardizer.standardize

        expect(address.commercial).to be_truthy
      end
    end

    context "for a non-commercial address" do
      it "sets the commercial field to false" do
        FakeLob.return_complete_match(
          address_type: "residential"
        )
        address = build(:fake_address)
        standardizer = Heimdall::AddressStandardizer.new(address)

        standardizer.standardize

        expect(address.commercial).to be_falsey
      end
    end

    def stub_verification_client
      client = Heimdall::Utils::AdapterFactory.build
      allow(Heimdall::Utils::AdapterFactory).
        to receive(:build).and_return(client)
      client
    end
  end
end
