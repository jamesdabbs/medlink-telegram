require "rails_helper"

describe Handlers::RegisterContact, handler: true do
  pending "can register a known phone number" do
    # FIXME: this breaks because the double doesn't update after we're logged in
    message = build :message, text: "", contact: build(:contact, user_id: 8241)
    run message: message

    expect(response).to use_handler Handlers::PromptForAction
  end
end
