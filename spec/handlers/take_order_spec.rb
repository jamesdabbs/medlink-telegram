require "rails_helper"

describe Handlers::TakeOrder, handler: true do
  describe "when logged in" do
    before(:each) { request.user = pcv }

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

  pending "gives feedback when orders aren't placed"
  # * supply doesn't exist
  # * supply isn't available
  # * supply is already on order
  # * medlink isn't reachable
end
