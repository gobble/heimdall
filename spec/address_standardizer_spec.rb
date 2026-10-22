require "spec_helper"

RSpec.describe Heimdall::AddressStandardizer do

  before { FakeLob.clear }

  describe "#deliverability_status" do
    it "returns the generic deliverability status as a symbol" do
      FakeLob.return_partial_match(
        deliverability_status: "deliverable_missing_unit"
      )
      standardizer = Heimdall::AddressStandardizer.new(build(:fake_address))

      result = standardizer.deliverability_status

      expect(result).to eq(:missing_unit)
    end

    context "when there is a verification error" do
      it "fails with UnverifiableAddressError" do
        client = stub_verification_client
        allow(client).to receive(:verify).
          and_raise(RestClient::SSLCertificateNotVerified)
        standardizer = Heimdall::AddressStandardizer.new(build(:fake_address))

        expect {
          standardizer.deliverability_status
        }.to raise_error(Heimdall::UnverifiableAddressError)
      end
    end
  end

  describe "#primary_field" do
    it "returns the primary street line from the verification response" do
      stub_verification_response(primary_field: "939 Industrial Ave")
      address = build(:fake_address)
      standardizer = Heimdall::AddressStandardizer.new(address)

      result = standardizer.primary_field

      expect(result).to eq("939 Industrial Ave")
    end
  end

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
  end

  def stub_verification_response(attributes)
    response = build(:verification_response, attributes)
    client = stub_verification_client
    allow(client).to receive(:verify).and_return(response)
    response
  end

  def stub_verification_client
    client = Heimdall::Utils::AdapterFactory.build
    allow(Heimdall::Utils::AdapterFactory).
      to receive(:build).and_return(client)
    client
  end
end
