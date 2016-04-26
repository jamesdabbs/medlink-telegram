require "rails_helper"

describe Handlers::Start, handler: true do
  it { should route "/start" }
  it { should route "Start" }
  it { should route " start \n" }

  it "asks for contact info if needed" do
    run user: nil, text: "/start"
    expect(messages.count).to eq 1
    expect(messages.first.text).to match \
      /Welcome to Medlink! We'll need your phone number/i
    expect(messages.first.keyboard.first.first.request_contact).to eq true
  end

  it "welcomes a user with contact info" do
    user = double "User", first_name: "User"

    run user: user, text: "/start"
    expect(messages.count).to eq 2
    expect(messages.first.text).to eq "Welcome back!"
    expect(messages.last.text).to eq "What can I do for you, User?"
    expect(messages.last.buttons).to eq [
      "Show Supply List",
      "Show Order History"
    ]
  end
end
