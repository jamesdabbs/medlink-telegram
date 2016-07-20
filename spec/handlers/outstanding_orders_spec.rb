require "rails_helper"

describe Handlers::OutstandingOrders, handler: true do
  before(:each) { self.user = pcv }

  it { should route "show orders" }
  it { should route "outstanding orders" }

  it "responds if you have no orders" do
    expect(bot.medlink).to receive(:outstanding_orders).and_return []

    run

    expect(replies).to eq ["You don't appear to have any outstanding orders."]
  end

  it "shows past orders" do
    orders = 3.times.map { build Medlink::Order }
    expect(bot.medlink).to receive(:outstanding_orders).and_return orders

    run

    orders.each do |o|
      expect(replies.map(&:text).join "\n").to include o.supply.name
    end
  end
end
