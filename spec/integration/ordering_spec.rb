require "rails_helper"

describe "Ordering", integration: true do
  context "standard testbot" do
    let(:bot) { testbot db: true }

    it "can order successfully" do
      say "/start"
      see /welcome to medlink/i

      expect(bot.medlink).to receive(:credentials_for_phone_number).
        and_return Medlink::Client::Credentials.new(user_id: 2622, token: "ordering-token")
      send_contact_info
      see /what can i do for you/i, buttons: 3

      click /place.*order/i
      see   /say.*list.*or.*say.*done/i

      expect(bot.medlink).to receive(:available_supplies).
        at_least(1).times.
        and_return supplies("Bandages", total: 3)
      say "list"
      expect(replies.last.text.lines.count).to eq 3
      expect(replies.last.text).to include "Bandages"

      expect(bot.medlink).to receive(:new_order)
      say "order bandages"
      see /Requested Bandages. Anything else?/

      say "done"
      see /cool/i
    end

    it "notifies when the telegram number doesn't match medlink" do
      say "/start"

      expect(bot.medlink).to receive(:credentials_for_phone_number).and_return nil
      send_contact_info

      see "It looks like your Telegram phone number doesn't match"
      see "I've notified @MedlinkSupport"
    end

    it "records when no commands match" do
      expect(bot.medlink).to receive(:credentials_for_phone_number).
        and_return Medlink::Client::Credentials.new(user_id: 2622, token: "ordering-token")
      send_contact_info
      say "trying to do something that the bot isn't ready for"

      receipts = Receipt.all
      expect(receipts.count).to eq 2
      expect(receipts.first).to be_handled
      expect(receipts.last.response.last.text).to include "support@pcmedlink.org"
      expect(receipts.last).not_to be_handled
    end
  end

  context "bot with errors" do
    let(:bot) { MedlinkTelegram.bot.with(
      recorder: Medbot.recorder,
      dispatch: ->(c) { raise "Bot failure" }
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
