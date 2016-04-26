require "rails_helper"

class ConstHandler < Handlers::Handler
  def applies?
    true
  end

  def run
    reply("Ok!")
  end
end

class FailHandler < Handlers::Handler
  def applies?
    true
  end

  def run
    fail "Whoops"
  end
end

describe Bot do
  let(:message) { Telegram::Bot::Types::Message.new(text: "Hello", from: { id: 2 }) }
  let(:request) { Bot::Request.new message }

  it "can successfully handle a message" do
    b = Bot.new handlers: [ConstHandler]

    r = b.handle request

    expect(r.messages).to eq ["Ok!"]

    m = Message.last
    expect(m.message.text).to eq "Hello"
    expect(m).to be_handled
    expect(m.error).to be_nil
  end

  it "records when no handlers are found" do
    b = Bot.new handlers: []

    r = b.handle request

    expect(r.messages.first.text).to include "sorry"

    m = Message.last
    expect(m.message.text).to eq "Hello"
    expect(m).not_to be_handled
    expect(m.error).to be_nil
  end

  it "records when a handler errors" do
    b = Bot.new handlers: [FailHandler]

    r = b.handle request
    expect(r.messages).to eq []

    m = Message.last
    expect(m.error["message"]).to eq "Whoops"
    expect(m.error["location"]).to be_an Array
  end
end
