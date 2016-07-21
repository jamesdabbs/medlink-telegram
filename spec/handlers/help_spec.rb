require "rails_helper"

describe Handlers::Help, handler: true do
  describe "when logged in" do
    before(:each) { self.user = pcv }

    it { should route "help" }
    it { should route "/help" }
    it { should_not route "/start" }

    it "shows help" do
      run
      expect(replies.first.buttons).to include "Place a New Order"
      expect(replies.last.text).to include '"support"'
    end
  end

  describe "not logged in" do
    it { should_not route "help" }
    it { should_not route "/help" }
  end
end
