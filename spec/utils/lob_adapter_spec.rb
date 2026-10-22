require "spec_helper"

RSpec.describe Heimdall::Utils::LobAdapter do
  describe ".build" do
    it "assigns the client" do
      client = Lob::Client.new(api_key: "key", api_version: "1")
      allow(Lob::Client).to receive(:new).and_return(client)

      adapter = Heimdall::Utils::LobAdapter.build

      expect(adapter.client).to eq(client)
    end
  end

  describe "#verify" do
    it "verifies the address" do
      client = stub_lob_client(build_lob_response)
      address = build(:fake_address, street2: "Apt. 1")
      adapter = Heimdall::Utils::LobAdapter.new(client: client)

      adapter.verify(address)

      expect(client).to have_received(:verify).with(
        primary_line: address.line1,
        secondary_line: address.line2,
        city: address.city,
        state: address.state,
        zip_code: address.zip_code
      )
    end

    it "returns a verification_response" do
      client = stub_lob_client(build_lob_response)
      adapter = Heimdall::Utils::LobAdapter.new(client: client)

      result = adapter.verify(build(:fake_address))

      expect(result).to be_kind_of(Heimdall::Utils::VerificationResponse)
    end

    it "maps the Lob response to generic attributes" do
      client = stub_lob_client(build_lob_response)
      adapter = Heimdall::Utils::LobAdapter.new(client: client)

      result = adapter.verify(build(:fake_address))

      expect(result).to have_attributes(
        street1: "123 Main Street",
        street2: "Apt. 1",
        primary_field: "123 N Main St",
        city: "Palo Alto",
        state: "CA",
        zip_code: "94303",
        deliverability_status: Heimdall::Utils::VerificationResponse::DELIVERABLE
      )
    end

    it "accepts responses with string keys" do
      client = stub_lob_client(build_lob_response.deep_stringify_keys)
      adapter = Heimdall::Utils::LobAdapter.new(client: client)

      result = adapter.verify(build(:fake_address))

      expect(result).to have_attributes(
        street1: "123 Main Street",
        zip_code: "94303"
      )
    end

    context "when Lob returns deliverable_missing_unit" do
      it "maps the deliverability to missing_unit" do
        response = build_lob_response.merge(
          deliverability: "deliverable_missing_unit"
        )
        client = stub_lob_client(response)
        adapter = Heimdall::Utils::LobAdapter.new(client: client)

        result = adapter.verify(build(:fake_address))

        expect(result.deliverability_status).
          to eq(Heimdall::Utils::VerificationResponse::MISSING_UNIT)
      end
    end

    context "when Lob returns an unknown deliverability" do
      it "defaults the deliverability to undeliverable" do
        response = build_lob_response.merge(deliverability: "no_match")
        client = stub_lob_client(response)
        adapter = Heimdall::Utils::LobAdapter.new(client: client)

        result = adapter.verify(build(:fake_address))

        expect(result.deliverability_status).
          to eq(Heimdall::Utils::VerificationResponse::UNDELIVERABLE)
      end
    end

    it "builds the primary_field from the street components" do
      response = build_lob_response.deep_merge(
        components: { street_predirection: "", street_postdirection: "W" }
      )
      client = stub_lob_client(response)
      adapter = Heimdall::Utils::LobAdapter.new(client: client)

      result = adapter.verify(build(:fake_address))

      expect(result.primary_field).to eq("123 Main St W")
    end

    context "when the Lob address_type is commercial" do
      it "is commercial" do
        response = build_lob_response.deep_merge(
          components: { address_type: "commercial" }
        )
        client = stub_lob_client(response)
        adapter = Heimdall::Utils::LobAdapter.new(client: client)

        result = adapter.verify(build(:fake_address))

        expect(result).to be_commercial
      end
    end

    context "when the Lob address_type is residential" do
      it "is not commercial" do
        client = stub_lob_client(build_lob_response)
        adapter = Heimdall::Utils::LobAdapter.new(client: client)

        result = adapter.verify(build(:fake_address))

        expect(result).to_not be_commercial
      end
    end

    context "when Lob returns a response without components" do
      it "returns a verification_response with the deliverability" do
        client = stub_lob_client(deliverability: "undeliverable")
        adapter = Heimdall::Utils::LobAdapter.new(client: client)

        result = adapter.verify(build(:fake_address))

        expect(result).to have_attributes(
          deliverability_status: Heimdall::Utils::VerificationResponse::UNDELIVERABLE,
          zip_code: nil,
          primary_field: "",
          commercial: false
        )
      end
    end

    def stub_lob_client(response)
      client = Lob::Client.new(api_key: "key", api_version: "1")
      allow(client).to receive(:verify).and_return(response)
      client
    end

    def build_lob_response
      {
        primary_line: "123 Main Street",
        secondary_line: "Apt. 1",
        deliverability: "deliverable",
        components: {
          primary_number: "123",
          street_predirection: "N",
          street_name: "Main",
          street_suffix: "St",
          street_postdirection: "",
          city: "Palo Alto",
          state: "CA",
          zip_code: "94303",
          address_type: "residential"
        }
      }
    end
  end
end
