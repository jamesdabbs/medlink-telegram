require "rails_helper"

describe NotificationsController, integration: true do
  let(:response_data) { {
    id:                55,
    extra_information: "We're out of foo",
    created_at:        20.days.ago,
    supplies: [
      { id: 5,  shortcode: "ASDF", name: "asdf", status: "delivery" },
      { id: 12, shortcode: "FOO",  name: "foo",  status: "purchase" },
      { id: 46, shortcode: "LULZ", name: "lulz", status: "denial"   }
    ]
  } }

  it "can notify a user that their order has been responded to" do
    pcv.save!

    response = post :response_created, params: { user_id: pcv.id, response: response_data, token: ENV["medlink_token"] }

    expect(response.status).to eq 200
    as pcv do
      see "We're out of foo"
      see /asdf.*delivery/
    end
  end

  it "does nothing if the user isn't in the database" do
    expect do
      post :response_created, params: { user_id: @chat_id, response: response_data, token: ENV["medlink_token"] }
    end.to raise_error ActiveRecord::RecordNotFound

    as pcv do
      expect(replies).to be_empty
    end
  end

  it "rejects requests that don't come from medlink" do
    pcv.save!

    response = post :response_created, params: { user_id: pcv.id, response: response_data, token: ENV["medlink_token"] + "x" }

    expect(response.status).to eq 401
    as pcv do
      expect(replies).to be_empty
    end
  end

  it "validates response" do
    pcv.save!

    response = post :response_created, params: { user_id: pcv.id, response: { id: 1, supplies: [] }, token: ENV["medlink_token"] }

    expect(response.status).to eq 422
  end

  it "can trigger a delivery check prompt" do
    pcv.save!

    response = post :check_delivery, params: { user_id: pcv.id, response: response_data, token: ENV["medlink_token"] }

    expect(response.status).to eq 200
    as pcv do
      see /Have you received your order for asdf, placed 20 days ago?/
    end
  end
end
