require "rails_helper"

describe Handlers::RegisterContact, handler: true do
  it "can register a known phone number" do
    message = build :message, text: "", contact: build(:contact, user_id: 8241)
    run message: message

    expect(response).to use_handler Handlers::PromptForAction
  end
end
