require "spec_helper"

RSpec.describe Heimdall::Address do

  describe "#for_comparison" do
    it "returns a comparable version of the address" do
      address = Heimdall::Address.new(line1: "939 Industrial Ave",
                                      city: "",
                                      state: "",
                                      zip_code: "94303")

      result = address.for_comparison

      expect(result).to eq("939 Industrial Ave, 94303")
    end
  end

  describe "#to_s" do
    it "returns a string representation of the address" do
      address = Heimdall::Address.new(line1: "939 Industrial Ave",
                                      line2: "UnitA",
                                      city: "San Francisco",
                                      state: "CA",
                                      zip_code: "94303")

      result = address.to_s

      expect(result).to eq("939 Industrial Ave, UnitA, San Francisco, CA 94303")
    end
  end

end
