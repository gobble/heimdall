require "spec_helper"

RSpec.describe Heimdall::Utils::VerificationResponse do
  describe "commercial?" do
    context "when address_type is commercial" do
      it "is commercial" do
        response = build(:verification_response, address_type: "commercial")

        expect(response).to be_commercial
      end
    end

    context "when address_type is residential" do
      it "is not commercial" do
        response = build(:verification_response, address_type: "residential")

        expect(response).to_not be_commercial
      end
    end
  end

  describe ".build" do
    it "returns a verification_response instance" do
      response = { components: {} }
      result = Heimdall::Utils::VerificationResponse.build(response)

      expect(result).to be_kind_of(Heimdall::Utils::VerificationResponse)
    end
  end

  describe "#primary_field" do
    it "builds the primary line field based on the primary components" do
      response = build(:verification_response, primary_number: 2277,
                                               street_predirection: "N",
                                               street_name: "5TH",
                                               street_suffix: "ST",
                                               street_postdirection: "")

      result = response.primary_field

      expect(result).to eq("2277 N 5TH ST")
    end
  end
end
