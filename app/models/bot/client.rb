class Bot
  class Client < Medlink.struct(:sender)
    def self.build
      t = Telegram::Bot::Client.new Figaro.env.telegram_token!
      new sender: ->(opts) { t.api.send_message opts }
    end

    def reply_to request, message
      message chat_id: request.chat_id, message: message
    end

    def message_user user, message
      message chat_id: user.telegram_id, message: message
    end

    def message_support text, markup: nil
      message_user User.support, Bot::Response::Item.new(text, markup: markup)
    end

    def inspect
      # :nocov:
      %|<#{self.class.name}>|
      # :nocov:
    end

    private

    def message chat_id:, message:
      sender.call chat_id: chat_id, message: message
    end
  end
end
