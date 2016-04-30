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
  let(:message) { Telegram::Bot::Types::Message.new(
    text: "Hello", from: { id: 2 }, chat: { id: 5 }
  ) }
  let(:request) { Bot::Request.new message }

  it "can successfully handle a message" do
    b = Bot.new handlers: [ConstHandler]

    expect(Bot).to receive(:message).with(chat_id: 5, text: "Ok!")

    expect do
      b.handle request: request
    end.to change { Message.count }.by 1

    m = Message.last
    expect(m).to be_handled
    expect(m.error).to be_nil
    expect(m.message.text).to eq "Hello"
    expect(m.response.first["text"]).to eq "Ok!"
  end

  it "records when no handlers are found" do
    b = Bot.new handlers: []

    expect(Bot).to receive(:message).twice

    expect do
      b.handle request: request
    end.to change { Message.count }.by 1

    m = Message.last
    expect(m).not_to be_handled
    expect(m.error).to be_nil
    expect(m.message.text).to eq "Hello"
    expect(m.response.first["text"]).to include "sorry"
  end

  it "records when a handler errors" do
    b = Bot.new handlers: [FailHandler], error_handler: Handlers::Error

    expect do
      b.handle request: request
    end.to change { Message.count }.by 1

    expect(Bot.messages.last[:text]).to match /something went wrong/i

    m = Message.last
    expect(m.error["message"]).to eq "Whoops"
    expect(m.error["location"]).to be_an Array
  end
end
