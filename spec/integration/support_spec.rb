require "rails_helper"

describe "Getting registration help", integration: true do
  let(:bot) { testbot db: true }

  it "lets users ask for help" do
    pcv.save! # we'll need to reload

    as pcv do
      say "I don't know what to do"
      say "support"
      see /paged.*support/i
    end

    expect(pcv.reload.needs_help?).to eq true

    as_support do
      see /@#{pcv.telegram_username}.*needs.*help/
      see /I don\'t know what to do/
      click /Done/
    end

    expect(pcv.reload.needs_help?).to eq false
  end
end
