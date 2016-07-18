require "rails_helper"

describe SupplyFinder do
  describe "with a few supplies" do
    before :each do
      supplies = [
        double("Supply", name: "Bandages", shortcode: "BANDG"),
        double("Supply", name: "Mosquito Nets", shortcode: "MOSQN")
      ]

      medlink = instance_double Medlink::User::Client

      expect(medlink).to receive(:available_supplies).and_return supplies

      @finder = SupplyFinder.new medlink: medlink
    end

    it "can look up by shortcode" do
      result = @finder.run %w( bandg mosqn )
      expect(result.recognized.map &:name).to eq ["Bandages", "Mosquito Nets"]
      expect(result.unrecognized).to eq []
    end

    it "can fail to find some things" do
      result = @finder.run %w( asdf bandg zxcv )
      expect(result.recognized.map &:name).to eq ["Bandages"]
      expect(result.unrecognized).to eq %w( asdf zxcv )
    end

    it "can find by name" do
      result = @finder.run ["mosquito nets", "bandages"]
      expect(result.recognized.map &:shortcode).to eq %w( MOSQN BANDG )
    end

    pending "can suggest fuzzy name matches"
  end
end
