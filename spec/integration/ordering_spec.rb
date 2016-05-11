require "rails_helper"

describe "Ordering", integration: true do
  context "standard testbot" do
    let(:bot) { testbot }

    it "can order successfully" do
      say "/start"
      see /welcome to medlink/i

      send_contact_info
      see /what can i do for you/i, buttons: 3

      click /place.*order/i
      see /say.*list.*or.*say.*done/i

      expect(medlink).to receive(:available_supplies).
        at_least(1).times.
        and_return [build(Supply, name: "Bandages"), build(Supply)]
      say "list"
      expect(replies.last.text.lines.count).to eq 2
      expect(replies.last.text).to include "Bandages"

      expect(medlink).to receive(:new_order)
      say "order bandages"
      see /Requested Bandages. Anything else?/

      say "done"
      see /cool/i
    end

    it "records when no commands match" do
      send_contact_info
      say "trying to do something that the bot isn't ready for"

      expect(receipts.count).to eq 2
      expect(receipts.first).to be_handled
      expect(receipts.last.response.last.text).to include "support@pcmedlink.org"
      expect(receipts.last).not_to be_handled
    end
  end

  context "bot with errors" do
    let(:bot) { Medbot.with(
      dispatch:  ->(c) { raise "Bot failure" }
    ) }

    it "records failures" do
      expect do
        say "/start"
      end.to change { Receipt.count }.by 1

      r = Receipt.last
      expect(r.request.text).to eq "/start"
      expect(r.error.message).to eq "Bot failure"
      expect(r.response.first.text).to include "something went wrong"
    end
  end
end
