require "rails_helper"

describe TelegramController do
  let(:update) {
    {
      message: {
        text: "asdfasdf",
        from: {
          id: 1234,
          first_name: "First"
        },
        chat: {
          id: 5678
        }
      }
    }
  }

  it "can receive an update" do
    expect do
      post :receive, params: { token: Figaro.env.telegram_token!, telegram: update }
    end.to change { Message.count }.by 1

    expect(response).to be_successful

    m = Message.last
    expect(m).to be_handled
    expect(m.error).to be_nil
    expect(m.response.first["text"]).to match /welcome.*number/i
  end

  it "requires a token" do
    expect do
      post :receive, params: { token: "", telegram: update }
    end.not_to change { Message.count }

    expect(response).to be_bad_request
  end

  it "errors with a bad token" do
    token = Figaro.env.telegram_token! + "a"
    expect do
      post :receive, params: { token: token, telegram: update }
    end.not_to change { Message.count }

    expect(response).to be_bad_request
  end
end
