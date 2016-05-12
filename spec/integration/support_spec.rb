require "rails_helper"

describe "Getting registration help", integration: true do
  let(:bot) { testbot }

  pending "can get help" do
    pcv.save! # we'll need to reload

    as pcv do
      send_contact_info
      say "I don't know what to do"
      say "support"
      see /paged.*support/i
    end

    expect(pcv.reload.needs_help?).to eq true

    as :support do
      see /@#{user.username}.*needs.*help/
      see /I don\'t know what to do/
      click "Done"
    end

    expect(pcv.reload.needs_help?).to eq false
  end
end
