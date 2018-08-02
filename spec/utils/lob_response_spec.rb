require "spec_helper"

RSpec.describe Heimdall::Utils::LobResponse do

  describe "commercial?" do
    context "when address_type is commercial" do
      it "is commercial" do
        lob_response = build(:lob_response, address_type: "commercial")

        expect(lob_response).to be_commercial
      end
    end

    context "when address_type is residential" do
      it "is not commercial" do
        lob_response = build(:lob_response, address_type: "residential")

        expect(lob_response).to_not be_commercial
      end
    end
  end

  describe ".build" do
    it "returns a lob_response instance" do
      response = { components: {} }
      result = Heimdall::Utils::LobResponse.build(response)

      expect(result).to be_kind_of(Heimdall::Utils::LobResponse)
    end
  end

  describe "#primary_field" do
    it "builds the primary line field based on the primary components" do
      lob_response = build(:lob_response, primary_number: 2277,
                                          street_predirection: "N",
                                          street_name: "5TH",
                                          street_suffix: "ST",
                                          street_postdirection: "")

      result = lob_response.primary_field

      expect(result).to eq("2277 N 5TH ST")
    end
  end
end
