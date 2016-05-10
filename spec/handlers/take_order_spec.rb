require "rails_helper"

describe Handlers::TakeOrder, handler: true do
  describe "when logged in" do
    before(:each) { self.user = pcv }

    it { should route "/order thing" }
    it { should route "order something" }
    pending { should route " PLACE AN ORDER FOR THAT \n" }
  end

  describe "when not logged in" do
    it { should_not route "/order thing" }
    it { should_not route "order something" }
  end


  let(:bandages) { double "Supply", name: "Bandages", shortcode: "BANDG" }

  it "interacts with Medlink" do
    expect(medlink).to receive(:available_supplies).and_return [bandages]
    expect(medlink).to receive(:new_order).with(supplies: [bandages])

    run user: pcv, text: "order bandg"

    expect(replies).to eq [
      "Alright! Your order for Bandages is in the system. We'll get back to you ASAP."]
  end

  it "gives feedback on orders" do
    allow(medlink).to receive(:available_supplies).and_return []

    placer = instance_double OrderPlacer,
      new_orders:          [build(Supply, name: "a"), build(Supply, name: "b")],
      pre_existing_orders: [build(Supply, name: "c"), build(Supply, name: "d")],
      user_errors:         ["asdf", "zxcv"]
    allow(placer).to receive(:run)

    run user: pcv, text: "order things", with: { placer: placer }

    expect(replies).to eq [
      "Alright! Your order for a and b is in the system. We'll get back to you ASAP.",
      "You already had open orders for c and d, so I didn't update those. If you haven't gotten an item that you expect, please contact support@pcmedlink.org",
      "Something went wrong when trying to order asdf and zxcv."
    ]
  end

  # TODO: probably not. Should just retry job.
  pending "gives feedback if Medlink is down"
end
