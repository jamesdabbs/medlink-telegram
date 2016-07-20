require "medlink/struct"

class Bot < Medlink.struct(:dispatch, :recorder, :medlink, :telegram)
  def call message
    context = Handlers::Context.new(
      bot:      self,
      message:  message,
      response: Bot::Response.new(telegram: telegram),
    )

    recorder.call context do
      dispatch.call context
    end
  end

  def receive update:
    klass = update.callback_query ? Callback : Message
    call klass.from_update update
  end

  def callback key, sender_id: nil, **data
    call Callback.new key: key, sender_id: sender_id, data: data
  end

  def valid_token? token
    token == Figaro.env.telegram_token!
  end

  def update_from_telegram telegram
    Telegram::Bot::Types::Update.new JSON.parse(telegram.to_json)
  end
end
