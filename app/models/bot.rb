require "medlink/struct"

class Bot < Medlink.struct(:dispatch, :recorder, :telegram)
  def call message, medlink: nil
    context = Handlers::Context.new(
      bot:      self,
      message:  message,
      response: Bot::Response.new(telegram: telegram),
      medlink:  medlink,
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
