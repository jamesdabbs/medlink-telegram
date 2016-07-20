require "rails_helper"

describe OrderPlacer do
  it "can place an order" do
    medlink = instance_double Medlink::User::Client
    expect(medlink).to receive(:new_order)

    placer = OrderPlacer.new medlink: medlink, user: pcv
    placer.run supplies(total: 2)
  end
end
