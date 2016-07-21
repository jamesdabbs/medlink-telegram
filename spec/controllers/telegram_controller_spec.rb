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

  let(:callback) {
    {
      callback_query: {
        data: {
          key: :start_new_order
        }.to_json,
        from: {
          id:   1234,
          name: "Alice"
        }
      }
    }
  }

  it "can receive an update" do
    expect do
      post :receive, params: { token: Figaro.env.telegram_token!, telegram: update }
    end.to change { Receipt.count }.by 1

    expect(response).to be_successful

    r = Receipt.last
    expect(r).to be_handled
    expect(r.error).to be_nil
    expect(r.response.first.text).to match /welcome.*number/i
  end

  it "can receive a callback" do
    expect do
      post :receive, params: { token: Figaro.env.telegram_token!, telegram: callback }
    end.to change { Receipt.count }.by 1

    expect(response).to be_successful

    r = Receipt.last
    expect(r).to be_handled
    expect(r.error).to be_nil
    expect(r.response.first.text).to eq "Alright - what can I get for you?"
  end

  it "requires a token" do
    expect do
      post :receive, params: { token: "", telegram: update }
    end.not_to change { Receipt.count }

    expect(response).to be_bad_request
  end

  it "errors with a bad token" do
    token = Figaro.env.telegram_token! + "a"
    expect do
      post :receive, params: { token: token, telegram: update }
    end.not_to change { Receipt.count }

    expect(response).to be_bad_request
  end
end
