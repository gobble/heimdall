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
      client = Lob::Client.new(api_key: "key", api_version: "1")
      address = build(:fake_address)
      adapter = Heimdall::Utils::LobAdapter.new(client: client)
      verify_response = {
        primary_line: "123 Main Street",
        secondary_line: "",
        deliverability: "deliverable",
        components: {
          city: "city",
          state: "state",
          zip_code: "90210"
        }
      }
      allow(client).to receive(:verify).and_return(verify_response)

      adapter.verify(address)

      expect(client).to have_received(:verify)
    end
  end
end
