require "rails_helper"

describe Handlers::ShowSupplyList, handler: true do
  it "shows the list of supplies" do
    expect(medlink).to receive(:available_supplies).and_return [
      double("Supply", name: "Asdfs", shortcode: "ASDF"),
      double("Supply", name: "Bnms", shortcode: "BNM")
    ]

    run user: pcv

    expect(replies.last.text).to include "ASDF"
    expect(replies.last.text).to include "BNM"
  end
end
