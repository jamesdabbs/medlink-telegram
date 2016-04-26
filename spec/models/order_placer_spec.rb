require "rails_helper"

describe OrderPlacer do
  it "can place an order" do
    medlink = instance_double Medlink
    expect(medlink).to receive(:new_order)

    placer = OrderPlacer.new medlink: medlink
    placer.run [make_supply]
  end
end
