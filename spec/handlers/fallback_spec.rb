require "rails_helper"

describe Handlers::Fallback, handler: true do
  describe "logged in" do
    before(:each) { request.user = pcv }

    it { should route "kajsdnflkajsnd" }
    it { should_not route "start" }
  end

  describe "logged out" do
    it { should_not route "kajsdnflkajsnd" }
    it { should_not route "start" }
  end
end
