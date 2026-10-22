require "spec_helper"

RSpec.describe Heimdall::Utils::VerificationResponse do
  describe ".new" do
    it "assigns the generic address attributes" do
      response = Heimdall::Utils::VerificationResponse.new(
        street1: "939 Industrial Ave",
        street2: "Apt. 1",
        primary_field: "939 Industrial Ave",
        city: "Palo Alto",
        state: "CA",
        zip_code: "94303",
        deliverability: :deliverable
      )

      expect(response).to have_attributes(
        street1: "939 Industrial Ave",
        street2: "Apt. 1",
        primary_field: "939 Industrial Ave",
        city: "Palo Alto",
        state: "CA",
        zip_code: "94303",
        deliverability: :deliverable
      )
    end

    it "requires a deliverability" do
      expect {
        Heimdall::Utils::VerificationResponse.new(street1: "939 Industrial Ave")
      }.to raise_error(ArgumentError)
    end
  end

  describe "#commercial?" do
    context "when the address is commercial" do
      it "is commercial" do
        response = build(:verification_response, commercial: true)

        expect(response).to be_commercial
      end
    end

    context "when the address is not commercial" do
      it "is not commercial" do
        response = build(:verification_response, commercial: false)

        expect(response).to_not be_commercial
      end
    end
  end

  describe "#deliverable?" do
    context "when the address is deliverable" do
      it "is deliverable" do
        response = build(:verification_response, deliverability: :deliverable)

        expect(response).to be_deliverable
      end
    end

    context "when the address is not deliverable" do
      it "is not deliverable" do
        response = build(:verification_response, deliverability: :missing_unit)

        expect(response).to_not be_deliverable
      end
    end
  end
end
