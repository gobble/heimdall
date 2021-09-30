require "spec_helper"

RSpec.describe Heimdall::Utils::AdapterFactory do
  describe ".build" do
    it "returns a verification adapter" do
      result = Heimdall::Utils::AdapterFactory.build

      expect(result).to respond_to(:verify)
    end
  end

  describe "#create" do
    context "when lob is set as the provider" do
      it "returns an instance of the Utils::LobAdapter" do
        factory = Heimdall::Utils::AdapterFactory.new(provider: "lob")

        result = factory.create

        expect(result).to be_an_instance_of(Heimdall::Utils::LobAdapter)
      end
    end
  end
end
