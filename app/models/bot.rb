require "medlink/struct"

class Bot < Medlink.struct(:dispatch, :recorder, :telegram)
  def call message, medlink: nil, user: nil
    context = Handlers::Context.new(
      bot:      self,
      message:  message,
      response: Bot::Response.new(telegram: telegram),
      medlink:  medlink,
      user:     user
    )

    recorder.call context do
      dispatch.call context
    end
  end

  def receive update:
    message = update.message || update.callback.query
    call message
  end

  def valid_token? token
    token == Figaro.env.telegram_token!
  end

  def update_from_telegram telegram
    Telegram::Bot::Types::Update.new JSON.parse(telegram.to_json)
  end
end
