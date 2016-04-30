require "rails_helper"

describe Medlink do
  it "authorizes requests with a phone number" do
    medlink = Medlink.new phone: "867-5309", runner: ->(req) {
      expect(req.url).to end_with "/auth/phone"

      { id: 5, secret_key: "asdf" }.to_json
    }

    expect(medlink).to be_authorized
  end

  it "can find available supplies" do
    medlink = Medlink.new runner: ->(req) {
      expect(req.url).to end_with "/supplies"

      {
        supplies: [
          { id: 1, name: "Name", shortcode: "CODE" }
        ]
      }.to_json
    }

    supply = medlink.available_supplies.first
    expect(supply.name).to eq "Name"
  end

  it "can make a new request" do
    medlink = Medlink.new runner: ->(req) {
      expect(req.method).to eq :post
      expect(req.url).to end_with "/requests"

      { status: :ok }.to_json
    }

    medlink.new_order supplies: [build(Supply)]
  end

  it "can view outstanding orders" do
    medlink = Medlink.new runner: ->(req) {
      expect(req.url).to end_with "/orders"

      {
        orders: 3.times.map do
          {
            supply: { id: rand(1 .. 1000), name: rand.to_s, shortcode: rand.to_s },
            placed_at: rand(1 .. 400).days.ago
          }
        end
      }.to_json
    }

    orders = medlink.outstanding_orders
    expect(orders.count).to eq 3
    expect(orders.first).to be_an Order
  end
end
