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

end
